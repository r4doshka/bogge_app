import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/models/router/router_model.dart';
import 'package:bogge_app/providers/auth/auth_provider.dart';
import 'package:bogge_app/providers/auth/route_stack_notifier.dart';
import 'package:bogge_app/providers/navigation/routers/app_router.dart';
import 'package:bogge_app/services/navigator_observers/common/common_navigator_observer.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:flutter/material.dart';

import 'package:bogge_app/providers/navigation/routers/authorized/authorized_router.gr.dart'
    as auth;
import 'package:bogge_app/providers/navigation/routers/guest/guest_router.gr.dart'
    as guest;
import 'package:bogge_app/providers/navigation/routers/un_authorized/un_authorized_router.gr.dart'
    as un_authorized;
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NavigationService {
  final Ref ref;
  final CommonNavigatorObserver _navigatorObserver;
  final ValueNotifier<AppRouter> _appRouterNotifier;

  NavigationService({
    required this.ref,
    required CommonNavigatorObserver navigatorObserver,
    required ValueNotifier<AppRouter> appRouterNotifier,
  }) : _navigatorObserver = navigatorObserver,
       _appRouterNotifier = appRouterNotifier;

  BuildContext? layoutContext;
  TabsRouter? tabsRouter;

  void goToGuestMode(BuildContext context) {
    ref.read(authProvider.notifier).setCurrentFlow(FlowType.guest);
    _navigatorObserver.clearStack();
    ref
        .read(routeStackProvider.notifier)
        .update((s) => RouteStackType.guestMode);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _appRouterNotifier.value.replaceAll([const guest.GuestWelcomeRoute()]);
    });
  }

  void goToSignIn(BuildContext context) {
    ref.read(authProvider.notifier).setCurrentFlow(FlowType.unauthorized);
    _navigatorObserver.clearStack();
    ref
        .read(routeStackProvider.notifier)
        .update((s) => RouteStackType.unAuthorized);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _appRouterNotifier.value.pushAndPopUntil(
        const un_authorized.SignInRoute(),
        predicate: (_) => false,
      );
    });
  }

  void goToSignUp(BuildContext context) {
    ref.read(authProvider.notifier).setCurrentFlow(FlowType.unauthorized);
    _navigatorObserver.clearStack();
    ref
        .read(routeStackProvider.notifier)
        .update((s) => RouteStackType.unAuthorized);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _appRouterNotifier.value.pushAndPopUntil(
        const un_authorized.SignUpRoute(),
        predicate: (_) => false,
      );
    });
  }

  void goToAuthorizedMode(BuildContext context) {
    ref.read(authProvider.notifier).setCurrentFlow(FlowType.authorized);
    _navigatorObserver.clearStack();
    ref
        .read(routeStackProvider.notifier)
        .update((s) => RouteStackType.authorized);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _appRouterNotifier.value.replaceAll([const auth.AuthorizedLoadRoute()]);
    });
  }

  void goToUnAuthorizedMode(BuildContext context) {
    ref.read(authProvider.notifier).setCurrentFlow(FlowType.unauthorized);
    ref
        .read(routeStackProvider.notifier)
        .update((s) => RouteStackType.unAuthorized);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _appRouterNotifier.value.replaceAll([const un_authorized.WelcomeRoute()]);
    });
  }

  void goToSplashScreen(BuildContext context) {
    ref.read(authProvider.notifier).setCurrentFlow(FlowType.init);
    ref.read(routeStackProvider.notifier).update((s) => RouteStackType.init);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _appRouterNotifier.value.replaceAll([const auth.SplashRoute()]);
    });
  }

  void pop() {
    try {
      _appRouterNotifier.value.pop();
    } catch (e, stack) {
      debugPrint('NavigationService pop =====> $e');
      debugPrint('NavigationService pop =====> $stack');
    }
  }
}

final navigationServiceProvider = Provider<NavigationService>((ref) {
  return NavigationService(
    ref: ref,
    navigatorObserver: ref.read(commonNavigatorObserverProvider),
    appRouterNotifier: ref.read(appRouterNotifierProvider),
  );
});
