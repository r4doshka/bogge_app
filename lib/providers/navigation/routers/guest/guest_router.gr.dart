// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:bogge_app/ui/screens/authorized/loading/authorized_load_screen.dart'
    as _i1;
import 'package:bogge_app/ui/screens/guest/welcome_screen/guest_welcome_screend.dart'
    as _i2;
import 'package:bogge_app/ui/screens/init/splash_screen/splash_screen.dart'
    as _i5;
import 'package:bogge_app/ui/screens/unauthorized/sign_in_screen/sign_in_screen.dart'
    as _i3;
import 'package:bogge_app/ui/screens/unauthorized/sign_up_screen/sign_up_screen.dart'
    as _i4;
import 'package:bogge_app/ui/screens/unauthorized/welcome_screen/welcome_screen.dart'
    as _i6;

/// generated route for
/// [_i1.AuthorizedLoadScreen]
class AuthorizedLoadRoute extends _i7.PageRouteInfo<void> {
  const AuthorizedLoadRoute({List<_i7.PageRouteInfo>? children})
    : super(AuthorizedLoadRoute.name, initialChildren: children);

  static const String name = 'AuthorizedLoadRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i1.AuthorizedLoadScreen();
    },
  );
}

/// generated route for
/// [_i2.GuestWelcomeScreen]
class GuestWelcomeRoute extends _i7.PageRouteInfo<void> {
  const GuestWelcomeRoute({List<_i7.PageRouteInfo>? children})
    : super(GuestWelcomeRoute.name, initialChildren: children);

  static const String name = 'GuestWelcomeRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.GuestWelcomeScreen();
    },
  );
}

/// generated route for
/// [_i3.SignInScreen]
class SignInRoute extends _i7.PageRouteInfo<void> {
  const SignInRoute({List<_i7.PageRouteInfo>? children})
    : super(SignInRoute.name, initialChildren: children);

  static const String name = 'SignInRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.SignInScreen();
    },
  );
}

/// generated route for
/// [_i4.SignUpScreen]
class SignUpRoute extends _i7.PageRouteInfo<void> {
  const SignUpRoute({List<_i7.PageRouteInfo>? children})
    : super(SignUpRoute.name, initialChildren: children);

  static const String name = 'SignUpRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.SignUpScreen();
    },
  );
}

/// generated route for
/// [_i5.SplashScreen]
class SplashRoute extends _i7.PageRouteInfo<void> {
  const SplashRoute({List<_i7.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.SplashScreen();
    },
  );
}

/// generated route for
/// [_i6.WelcomeScreen]
class WelcomeRoute extends _i7.PageRouteInfo<void> {
  const WelcomeRoute({List<_i7.PageRouteInfo>? children})
    : super(WelcomeRoute.name, initialChildren: children);

  static const String name = 'WelcomeRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.WelcomeScreen();
    },
  );
}
