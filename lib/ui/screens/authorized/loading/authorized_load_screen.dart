import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/providers/auth/auth_provider.dart';
import 'package:bogge_app/services/initializer/app_data_initializer.dart';
import 'package:bogge_app/services/navigation_service.dart';
import 'package:bogge_app/services/network_connectivity_notifier.dart';
import 'package:bogge_app/ui/widgets/loading_logo.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:bogge_app/utils/storage.dart';
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
        _needsRetryInitialization = false;
        initialization();
      }
    };
    _connectivityNotifier.addListener(_connectivityListener);

    _tryInitialization();
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
      // final userStore = getIt.get<UserStore>();
      // final tokenStatus = await userStore.checkToken();
      // switch (tokenStatus) {
      //   case TokenStatus.active:
      //     await _handleValidToken();
      //     return true;

      //   case TokenStatus.inactive:
      //     await _handleInvalidToken();
      //     return false;

      //   case TokenStatus.offline:
      //     _needsRetryInitialization = true;
      //     return _handleNetworkError();
      // }
      return true;
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
    await _navigate();
    await ref.read(appDataInitializerProvider).initialize();
  }

  Future<void> _navigate() async {
    final stopwatch = Stopwatch()..start();
    await _navigateToTabBar();
    stopwatch.stop();
    debugPrint(
      '_checkAppVersionAndNavigate took ${stopwatch.elapsedMilliseconds} ms',
    );
  }

  Future<void> _navigateToTabBar() async {
    ref.read(authProvider.notifier).setCurrentFlow(FlowType.authorized);
    await Future.delayed(Duration(milliseconds: 10));
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // context.router.replace(const auth.TabBarNavigatorMain());
      });
    }
  }

  Future<void> _handleInvalidToken() async {
    await Storage.clearStorage();
    if (mounted) {
      ref.read(navigationServiceProvider).goToSignIn(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // FlutterNativeSplash.remove();
      ref.read(navigationServiceProvider).layoutContext = context;
    });

    return const PopScope(
      canPop: false,
      child: Scaffold(body: Center(child: LoadingLogo())),
    );
  }
}
