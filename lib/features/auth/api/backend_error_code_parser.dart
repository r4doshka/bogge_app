import 'package:bogge_app/features/auth/models/sign_up_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

enum AuthBackendErrorCode { userAlreadyExists, invalidCredentials, unknown }

extension BackendErrorCodeX on AuthBackendErrorCode {
  static AuthBackendErrorCode fromCode(String? code) {
    switch (code) {
      case 'USER_ALREADY_EXISTS':
        return AuthBackendErrorCode.userAlreadyExists;
      case 'INVALID_CREDENTIALS':
        return AuthBackendErrorCode.invalidCredentials;
      default:
        return AuthBackendErrorCode.unknown;
    }
  }
}

void handleFormError({
  required AuthBackendErrorCode code,
  required FormGroup form,
  required BuildContext context,
}) {
  switch (code) {
    case AuthBackendErrorCode.userAlreadyExists:
      final control = form.control(SignUpState.emailFieldName);
      control
        ..setErrors({'emailInvalid': true})
        ..markAsTouched()
        ..markAsDirty();

      return;

    case AuthBackendErrorCode.invalidCredentials:
      break;

    case AuthBackendErrorCode.unknown:
      break;
  }

  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text('Что-то пошло не так'.tr())));
}
