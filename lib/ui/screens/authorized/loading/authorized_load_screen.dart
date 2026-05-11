import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/auth/api/auth_api.dart';
import 'package:bogge_app/features/user/providers/user_provider.dart';
import 'package:bogge_app/providers/auth/auth_provider.dart';
import 'package:bogge_app/providers/navigation/routers/authorized/authorized_router.gr.dart';
import 'package:bogge_app/providers/storage_provider.dart';
import 'package:bogge_app/services/initializer/app_data_initializer.dart';
import 'package:bogge_app/services/navigation_service.dart';
import 'package:bogge_app/services/network_connectivity_notifier.dart';
import 'package:bogge_app/ui/widgets/loading_logo.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class AuthorizedLoadScreen extends ConsumerStatefulWidget {
  const AuthorizedLoadScreen({super.key});

  @override
  AuthorizedLoadState createState() => AuthorizedLoadState();
}

class AuthorizedLoadState extends ConsumerState<AuthorizedLoadScreen> {
  bool _needsRetryInitialization = false;
  bool _isInitializing = false;
  late final NetworkConnectivityNotifier _connectivityNotifier;
  late final VoidCallback _connectivityListener;

  @override
  void initState() {
    super.initState();
    _connectivityNotifier = ref.read(networkConnectivityProvider);
    _connectivityListener = () {
      if (_connectivityNotifier.hasConnection && _needsRetryInitialization) {
        _tryInitialization();
      }
    };
    _connectivityNotifier.addListener(_connectivityListener);
    _tryInitialization();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // FlutterNativeSplash.remove();
      if (!mounted) return;
      ref.read(navigationServiceProvider).layoutContext = context;
    });
  }

  @override
  void dispose() {
    _connectivityNotifier.removeListener(_connectivityListener);
    super.dispose();
  }

  void _tryInitialization() {
    if (_isInitializing) {
      return;
    }
    _isInitializing = true;
    initialization().whenComplete(() {
      _isInitializing = false;
    });
  }

  Future<bool> initialization() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final tokenStatus = await ref.read(authRepository).checkToken();

      switch (tokenStatus) {
        case TokenStatus.active:
          _needsRetryInitialization = false;
          await _handleValidToken();
          return true;

        case TokenStatus.inactive:
          _needsRetryInitialization = false;
          await _handleInvalidToken();
          return false;

        case TokenStatus.offline:
          _needsRetryInitialization = true;
          return _handleNetworkError();
      }
    } catch (e, stack) {
      debugPrint('MainPageState initialization error: $e');
      debugPrint('MainPageState initialization error: $stack');
      return false;
    }
  }

  Future<bool> _handleNetworkError() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(networkConnectivityProvider).recheckConnection();
    });
    return false;
  }

  Future<void> _handleValidToken() async {
    final isInitialized = await ref
        .read(appDataInitializerProvider)
        .initialize();

    if (isInitialized != true) {
      await ref.read(authRepository).logout();
      await _clearStateAndNavigate();
      return;
    }

    final user = ref.read(userProvider);

    final steps = <({bool completed, PageRouteInfo route})>[
      (completed: user?.sex != null, route: const OnboardingGenderRoute()),
      (completed: user?.dateOfBirth != null, route: const OnboardingAgeRoute()),
      (completed: user?.height != null, route: const OnboardingHeightRoute()),
      (completed: user?.weight != null, route: const OnboardingWeightRoute()),
      (completed: user?.name != null, route: const OnboardingNameRoute()),
      (completed: true, route: const OnboardingAppleHealthRoute()),
    ];

    final firstIncompleteIndex = steps.indexWhere((step) => !step.completed);

    if (firstIncompleteIndex == -1) {
      await _navigate([const HomeRoute()]);
      return;
    }

    final routes = steps
        .take(firstIncompleteIndex + 1)
        .map((step) => step.route)
        .toList();

    await _navigate(routes);
  }

  Future<void> _navigate(List<PageRouteInfo> routeList) async {
    final stopwatch = Stopwatch()..start();
    ref.read(authProvider.notifier).setCurrentFlow(FlowType.authorized);
    await Future.delayed(Duration(milliseconds: 10));
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref.read(navigationServiceProvider).replaceAll(routeList);
      });
    }
    stopwatch.stop();
    debugPrint('_navigate took ${stopwatch.elapsedMilliseconds} ms');
  }

  Future<void> _handleInvalidToken() async {
    final isTokenRefreshed = await ref.read(authRepository).refreshToken();

    if (isTokenRefreshed) {
      await _handleValidToken();
      return;
    }
    await _clearStateAndNavigate();
    debugPrint('_handleInvalidToken go to sign in screen ');
  }

  Future<void> _clearStateAndNavigate() async {
    final storage = ref.read(storageServiceProvider);
    await storage.deleteAll();

    ref.read(authProvider.notifier).loadLoginState();
    if (mounted) {
      ref.read(navigationServiceProvider).goToSignIn(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: false,
      child: Scaffold(body: Center(child: LoadingLogo())),
    );
  }
}
