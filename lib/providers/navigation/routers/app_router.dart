import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/models/router/router_model.dart';
import 'package:bogge_app/providers/auth/route_stack_notifier.dart';
import 'package:bogge_app/providers/navigation/routers/authorized/authorized_router.dart';
import 'package:bogge_app/providers/navigation/routers/guest/guest_router.dart';
import 'package:bogge_app/providers/navigation/routers/init/init_router.dart';
import 'package:bogge_app/providers/navigation/routers/un_authorized/un_authorized_router.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appRouterNotifierProvider = Provider<ValueNotifier<AppRouter>>((ref) {
  return ValueNotifier(AppRouter(ref));
});

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  final Ref ref;

  AppRouter(this.ref);

  @override
  RouteType get defaultRouteType => RouteType.custom(
    transitionsBuilder: TransitionsBuilders.noTransition,
    duration: Duration.zero,
    reverseDuration: Duration.zero,
  );

  @override
  List<AutoRoute> get routes {
    final routeStack = ref.read(routeStackProvider);

    if (routeStack == RouteStackType.init) {
      return _initRoutes;
    }

    if (routeStack == RouteStackType.authorized) {
      return _authorizedRoutes;
    }

    if (routeStack == RouteStackType.guestMode) {
      return _guestRoutes;
    }

    if (routeStack == RouteStackType.unAuthorized) {
      return _unauthorizedRoutes;
    }

    return _unauthorizedRoutes;
  }

  List<AutoRoute> get _authorizedRoutes => AuthorizedRouter().routes;
  List<AutoRoute> get _unauthorizedRoutes => UnAuthorizedRouter().routes;
  List<AutoRoute> get _guestRoutes => GuestRouter().routes;
  List<AutoRoute> get _initRoutes => InitRouter().routes;
}
