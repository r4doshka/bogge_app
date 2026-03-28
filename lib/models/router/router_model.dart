enum AppRoutesList {
  mainOnboarding,
  signIn,
  signUp,
  signUpConfirmation,
  resetPasswordNew,
  resetPassword,
  authorizedLoad;

  const AppRoutesList();

  String get link => '/$name';
}

enum AppModalList {
  internetWarning;

  String get title => "${name}Modal";
}

enum RouteStackType { init, unAuthorized, authorized, guestMode }
