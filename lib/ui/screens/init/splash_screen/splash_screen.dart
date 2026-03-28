import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/providers/auth/auth_provider.dart';
import 'package:bogge_app/services/navigation_service.dart';
import 'package:bogge_app/ui/widgets/loading_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuth = ref.read(authProvider).isAuth;
    final navigationService = ref.read(navigationServiceProvider);

    useEffect(() {
      // FlutterNativeSplash.remove();
      Future(() async {
        try {
          if (!context.mounted) return;

          if (isAuth) {
            navigationService.goToAuthorizedMode(context);
          } else {
            navigationService.goToUnAuthorizedMode(context);
          }
        } catch (e) {
          debugPrint('SplashScreen error ====> $e');
          if (!context.mounted) return;
          navigationService.goToUnAuthorizedMode(context);
        }
      });

      return null;
    }, const []);

    return const PopScope(
      canPop: false,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Center(child: LoadingLogo())],
        ),
      ),
    );
  }
}
