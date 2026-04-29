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
    AutoRoute(page: OnboardingRoute.page, path: AppRoutesList.onboarding.link),
    AutoRoute(
      page: OnboardingGenderRoute.page,
      path: AppRoutesList.onboardingGender.link,
    ),
    AutoRoute(
      page: OnboardingAgeRoute.page,
      path: AppRoutesList.onboardingAge.link,
    ),
    AutoRoute(
      page: OnboardingHeightRoute.page,
      path: AppRoutesList.onboardingHeight.link,
    ),
    AutoRoute(
      page: OnboardingWeightRoute.page,
      path: AppRoutesList.onboardingWeight.link,
    ),
    AutoRoute(
      page: OnboardingNameRoute.page,
      path: AppRoutesList.onboardingName.link,
    ),
    AutoRoute(
      page: OnboardingAppleHealthRoute.page,
      path: AppRoutesList.onboardingAppleHealth.link,
    ),
    AutoRoute(page: HomeRoute.page, path: AppRoutesList.home.link),
    AutoRoute(
      page: UserProfileRoute.page,
      path: AppRoutesList.userProfile.link,
    ),
  ];
}
