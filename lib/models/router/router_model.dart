enum AppRoutesList {
  mainOnboarding,
  signIn,
  signUp,
  welcome,
  signUpConfirmation,
  resetPasswordNew,
  resetPassword,
  authorizedLoad;

  const AppRoutesList();

  String get link => '/$name';
}

enum AppModalList {
  internetWarning,
  userAgreement,
  privacyPolicy;

  String get title => "${name}Modal";
}

enum RouteStackType { init, unAuthorized, authorized, guestMode }
