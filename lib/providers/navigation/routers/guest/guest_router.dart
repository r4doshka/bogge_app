import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/providers/navigation/routers/guest/guest_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class GuestRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    CustomRoute(
      path: '/',
      initial: true,
      transitionsBuilder: TransitionsBuilders.noTransition,
      page: GuestWelcomeRoute.page,
    ),
  ];
}
