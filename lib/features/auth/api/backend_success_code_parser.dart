import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/providers/navigation/routers/un_authorized/un_authorized_router.gr.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum AuthSuccessCode { confirmationCodeSent, confirmationCodeResent, unknown }

extension AuthSuccessCodeX on AuthSuccessCode {
  static AuthSuccessCode fromCode(String? code) {
    switch (code) {
      case 'CONFIRMATION_CODE_SENT':
        return AuthSuccessCode.confirmationCodeSent;
      case 'CONFIRMATION_CODE_RESENT':
        return AuthSuccessCode.confirmationCodeResent;
      default:
        return AuthSuccessCode.unknown;
    }
  }
}

void handleFormSuccess({
  required BuildContext context,
  required AuthSuccessCode code,
  String email = '',
}) {
  switch (code) {
    case AuthSuccessCode.confirmationCodeSent:
    case AuthSuccessCode.confirmationCodeResent:
      context.router.push(SignUpConfirmationRoute(email: email));
      break;

    case AuthSuccessCode.unknown:
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Что-то пошло не так'.tr())));
      break;
  }
}
