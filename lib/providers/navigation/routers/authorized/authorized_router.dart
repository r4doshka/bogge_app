import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/models/router/router_model.dart';
import 'package:bogge_app/providers/navigation/routers/authorized/authorized_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AuthorizedRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: AuthorizedLoadRoute.page,
      path: AppRoutesList.authorizedLoad.link,
      initial: true,
    ),
  ];
}
