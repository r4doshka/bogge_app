import 'package:bogge_app/providers/navigation/routers/app_router.dart';
import 'package:bogge_app/providers/shared_preferences_provider.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/services/navigator_observers/common/common_navigator_observer.dart';
import 'package:bogge_app/services/navigator_observers/network/network_observer.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await ScreenUtil.ensureScreenSize();
  await EasyLocalization.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      child: EasyLocalization(
        supportedLocales: supportedLocales,
        startLocale: supportedLocales[0],
        path: 'assets/locales',
        child: MainApp(),
      ),
    ),
  );
}

class MainApp extends HookConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final palette = ref.watch(paletteProvider);
    final router = ref.watch(appRouterNotifierProvider);
    final navigatorObserver = ref.read(commonNavigatorObserverProvider);
    final networkDialogObserver = ref.read(networkDialogObserverProvider);

    return ScreenUtilInit(
      useInheritedMediaQuery: false,
      designSize: const Size(402, 874),
      minTextAdapt: true,
      builder: (context, child) => ValueListenableBuilder<AppRouter>(
        valueListenable: router,
        builder: (_, appRouter, __) {
          return MaterialApp.router(
            theme: ThemeData(
              fontFamily: "HarmonyOsSans",
              scaffoldBackgroundColor: palette.bgLight,
            ),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            routerDelegate: appRouter.delegate(
              navigatorObservers: () => [
                navigatorObserver,
                networkDialogObserver,
              ],
            ),
            routeInformationParser: appRouter.defaultRouteParser(),
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              final media = MediaQuery.of(context);
              final scale = media.textScaler.scale(1.0);

              return MediaQuery(
                data: media.copyWith(
                  textScaler: TextScaler.linear(scale.clamp(1.0, 1.55)),
                ),
                child: child ?? const SizedBox(),
              );
            },
          );
        },
      ),
    );
  }
}
