import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/providers/auth/auth_provider.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/services/navigation_service.dart';
import 'package:bogge_app/ui/widgets/loading_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationService = ref.read(navigationServiceProvider);
    final palette = ref.watch(paletteProvider);

    useEffect(() {
      FlutterNativeSplash.remove();
      Future(() async {
        try {
          // final storage = ref.read(storageServiceProvider);
          // await storage.clearStorage();

          await ref.read(authProvider.notifier).loadLoginState();
          if (!context.mounted) return;

          final isAuth = ref.read(authProvider).isAuth;
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

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: palette.primary,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Center(child: LoadingLogo())],
        ),
      ),
    );
  }
}
