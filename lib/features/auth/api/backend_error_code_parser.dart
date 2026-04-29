import 'package:bogge_app/features/auth/models/sign_in_state.dart';
import 'package:bogge_app/features/auth/models/sign_up_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

enum AuthBackendErrorCode {
  userAlreadyExists,
  invalidCredentials,
  invalidOrExpiredCode,
  invalidResponse,
  unknown,
}

extension BackendErrorCodeX on AuthBackendErrorCode {
  static AuthBackendErrorCode fromCode(String? code) {
    switch (code) {
      case 'USER_ALREADY_EXISTS':
        return AuthBackendErrorCode.userAlreadyExists;
      case 'INVALID_CREDENTIALS':
        return AuthBackendErrorCode.invalidCredentials;
      case 'INVALID_OR_EXPIRED_CODE':
        return AuthBackendErrorCode.invalidOrExpiredCode;
      case 'SERVER':
        return AuthBackendErrorCode.invalidResponse;
      default:
        return AuthBackendErrorCode.unknown;
    }
  }
}

void handleFormError({
  required AuthBackendErrorCode code,
  FormGroup? form,
  BuildContext? context,
}) {
  bool showSnackBar = true;

  switch (code) {
    case AuthBackendErrorCode.invalidResponse:
      return;

    case AuthBackendErrorCode.userAlreadyExists:
      return;

    case AuthBackendErrorCode.invalidCredentials:
      if (form != null) {
        final emailControl = form.control(SignInState.emailFieldName);
        final passwordControl = form.control(SignInState.passwordFieldName);
        emailControl
          ..setErrors({'required': true})
          ..markAsTouched()
          ..markAsDirty();
        passwordControl
          ..setErrors({'required': true})
          ..markAsTouched()
          ..markAsDirty();
      }
      break;

    case AuthBackendErrorCode.invalidOrExpiredCode:
      showSnackBar = false;
      break;

    case AuthBackendErrorCode.unknown:
      if (form != null) {
        final emailControl = form.control(SignUpState.emailFieldName);
        final passwordControl = form.control(SignUpState.passwordFieldName);
        emailControl
          ..setErrors({'required': true})
          ..markAsTouched()
          ..markAsDirty();
        passwordControl
          ..setErrors({'required': true})
          ..markAsTouched()
          ..markAsDirty();
      }
      break;
  }
  if (showSnackBar && context != null) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Что-то пошло не так'.tr())));
  }
}
