import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/providers/navigation/routers/init/init_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class InitRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    CustomRoute(
      path: '/',
      initial: true,
      transitionsBuilder: TransitionsBuilders.noTransition,
      page: SplashRoute.page,
    ),
  ];
}
