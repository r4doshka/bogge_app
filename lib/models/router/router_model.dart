enum AppRoutesList {
  mainOnboarding,
  signIn,
  signUp,
  welcome,
  signUpConfirmation,
  createNewPassword,
  resetPasswordConfirmation,
  resetPassword,
  authorizedLoad,
  onboarding,
  onboardingGender,
  onboardingAge,
  onboardingHeight,
  onboardingWeight,
  onboardingName,
  onboardingAppleHealth;

  const AppRoutesList();

  String get link => '/$name';
}

enum AppModalList {
  internetWarning,
  userAgreement,
  privacyPolicy,
  emptyProfile;

  String get title => "${name}Modal";
}

enum RouteStackType { init, unAuthorized, authorized, guestMode }
