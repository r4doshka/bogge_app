// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:bogge_app/ui/screens/authorized/loading/authorized_load_screen.dart'
    as _i1;
import 'package:bogge_app/ui/screens/guest/welcome_screen/guest_welcome_screend.dart'
    as _i2;
import 'package:bogge_app/ui/screens/init/splash_screen/splash_screen.dart'
    as _i7;
import 'package:bogge_app/ui/screens/unauthorized/reset_password_screen/reset_password_scree.dart'
    as _i3;
import 'package:bogge_app/ui/screens/unauthorized/sign_in_screen/sign_in_screen.dart'
    as _i4;
import 'package:bogge_app/ui/screens/unauthorized/sign_up_confirmation_screen/sign_up_confirmation_screen.dart'
    as _i5;
import 'package:bogge_app/ui/screens/unauthorized/sign_up_screen/sign_up_screen.dart'
    as _i6;
import 'package:bogge_app/ui/screens/unauthorized/welcome_screen/welcome_screen.dart'
    as _i8;
import 'package:flutter/material.dart' as _i10;

/// generated route for
/// [_i1.AuthorizedLoadScreen]
class AuthorizedLoadRoute extends _i9.PageRouteInfo<void> {
  const AuthorizedLoadRoute({List<_i9.PageRouteInfo>? children})
    : super(AuthorizedLoadRoute.name, initialChildren: children);

  static const String name = 'AuthorizedLoadRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i1.AuthorizedLoadScreen();
    },
  );
}

/// generated route for
/// [_i2.GuestWelcomeScreen]
class GuestWelcomeRoute extends _i9.PageRouteInfo<void> {
  const GuestWelcomeRoute({List<_i9.PageRouteInfo>? children})
    : super(GuestWelcomeRoute.name, initialChildren: children);

  static const String name = 'GuestWelcomeRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i2.GuestWelcomeScreen();
    },
  );
}

/// generated route for
/// [_i3.ResetPasswordScreen]
class ResetPasswordRoute extends _i9.PageRouteInfo<void> {
  const ResetPasswordRoute({List<_i9.PageRouteInfo>? children})
    : super(ResetPasswordRoute.name, initialChildren: children);

  static const String name = 'ResetPasswordRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i3.ResetPasswordScreen();
    },
  );
}

/// generated route for
/// [_i4.SignInScreen]
class SignInRoute extends _i9.PageRouteInfo<void> {
  const SignInRoute({List<_i9.PageRouteInfo>? children})
    : super(SignInRoute.name, initialChildren: children);

  static const String name = 'SignInRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i4.SignInScreen();
    },
  );
}

/// generated route for
/// [_i5.SignUpConfirmationScreen]
class SignUpConfirmationRoute
    extends _i9.PageRouteInfo<SignUpConfirmationRouteArgs> {
  SignUpConfirmationRoute({
    required String email,
    _i10.Key? key,
    List<_i9.PageRouteInfo>? children,
  }) : super(
         SignUpConfirmationRoute.name,
         args: SignUpConfirmationRouteArgs(email: email, key: key),
         initialChildren: children,
       );

  static const String name = 'SignUpConfirmationRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SignUpConfirmationRouteArgs>();
      return _i5.SignUpConfirmationScreen(email: args.email, key: args.key);
    },
  );
}

class SignUpConfirmationRouteArgs {
  const SignUpConfirmationRouteArgs({required this.email, this.key});

  final String email;

  final _i10.Key? key;

  @override
  String toString() {
    return 'SignUpConfirmationRouteArgs{email: $email, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SignUpConfirmationRouteArgs) return false;
    return email == other.email && key == other.key;
  }

  @override
  int get hashCode => email.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i6.SignUpScreen]
class SignUpRoute extends _i9.PageRouteInfo<void> {
  const SignUpRoute({List<_i9.PageRouteInfo>? children})
    : super(SignUpRoute.name, initialChildren: children);

  static const String name = 'SignUpRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i6.SignUpScreen();
    },
  );
}

/// generated route for
/// [_i7.SplashScreen]
class SplashRoute extends _i9.PageRouteInfo<void> {
  const SplashRoute({List<_i9.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i7.SplashScreen();
    },
  );
}

/// generated route for
/// [_i8.WelcomeScreen]
class WelcomeRoute extends _i9.PageRouteInfo<void> {
  const WelcomeRoute({List<_i9.PageRouteInfo>? children})
    : super(WelcomeRoute.name, initialChildren: children);

  static const String name = 'WelcomeRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i8.WelcomeScreen();
    },
  );
}
