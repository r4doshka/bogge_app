import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/models/router/router_model.dart';
import 'package:bogge_app/providers/navigation/routers/un_authorized/un_authorized_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class UnAuthorizedRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    CustomRoute(
      path: AppRoutesList.welcome.link,
      initial: true,
      transitionsBuilder: TransitionsBuilders.noTransition,
      page: WelcomeRoute.page,
    ),
    CustomRoute(
      path: AppRoutesList.signIn.link,
      transitionsBuilder: TransitionsBuilders.noTransition,
      page: SignInRoute.page,
    ),
    CustomRoute(
      path: AppRoutesList.signUp.link,
      transitionsBuilder: TransitionsBuilders.noTransition,
      page: SignUpRoute.page,
    ),
    CustomRoute(
      path: AppRoutesList.signUpConfirmation.link,
      transitionsBuilder: TransitionsBuilders.noTransition,
      page: SignUpConfirmationRoute.page,
    ),
    CustomRoute(
      path: AppRoutesList.resetPassword.link,
      transitionsBuilder: TransitionsBuilders.noTransition,
      page: ResetPasswordRoute.page,
    ),
    CustomRoute(
      path: AppRoutesList.resetPasswordConfirmation.link,
      transitionsBuilder: TransitionsBuilders.noTransition,
      page: ResetPasswordConformEmailRoute.page,
    ),
    CustomRoute(
      path: AppRoutesList.createNewPassword.link,
      transitionsBuilder: TransitionsBuilders.noTransition,
      page: CreateNewPasswordRoute.page,
    ),
  ];
}
