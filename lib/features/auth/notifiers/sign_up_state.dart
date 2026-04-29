import 'package:bogge_app/features/auth/models/sign_up_state.dart';
import 'package:bogge_app/utils/validators/common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:string_extensions/string_extensions.dart';

class SignUpFormStateNotifier extends StateNotifier<SignUpState> {
  final Ref ref;

  final textController = TextEditingController();
  late final PinInputController pinController;

  SignUpFormStateNotifier(this.ref) : super(SignUpState.unknown()) {
    pinController = PinInputController(textController: textController);
  }

  void reset() {
    state = SignUpState.unknown();

    pinController.clear();
    textController.clear();
  }

  void clearConfirmCodeFlow() {
    pinController.clear();
    textController.clear();

    final json = state.toJson();
    state = SignUpState.fromJson({
      ...json,
      "confirmCode": null,
      "confirmCodeErrors": null,
    });
  }

  void updateConfirmCode(String? code) {
    if (code == state.confirmCode || code == null) {
      return;
    }

    final confirmCode = code.trimAll;
    if (confirmCode.isEmpty) return;

    final json = state.toJson();

    state = SignUpState.fromJson({
      ...json,
      "confirmCode": confirmCode,
      "confirmCodeErrors": null,
    });
  }

  bool get enableConfirmCodeSubmit =>
      state.confirmCode != null &&
      state.confirmCode?.length == 6 &&
      state.confirmCodeErrors == null;

  bool validateConfirmCode() {
    final json = state.toJson();

    final confirmCodeErrors = Validators.faCodeValidator(
      code: state.confirmCode,
    );

    if (confirmCodeErrors != null) {
      state = SignUpState.fromJson({
        ...json,
        "confirmCodeErrors": confirmCodeErrors,
      });

      pinController.triggerError();
      return false;
    }

    if (!enableConfirmCodeSubmit) return false;

    return true;
  }

  void setConfirmCodeError() {
    final json = state.toJson();
    state = SignUpState.fromJson({
      ...json,
      "confirmCodeErrors": "Неверный код".tr(),
    });
    pinController.triggerError();
  }
}
