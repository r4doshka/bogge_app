import 'package:bogge_app/features/auth/models/change_email_state.dart';
import 'package:bogge_app/utils/validators/common.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:string_extensions/string_extensions.dart';

class ChangeEmailFormStateNotifier extends StateNotifier<ChangeEmailState> {
  final Ref ref;

  final textController = TextEditingController();
  late final PinInputController pinController;

  ChangeEmailFormStateNotifier(this.ref) : super(ChangeEmailState.unknown()) {
    pinController = PinInputController(textController: textController);
  }

  void reset() {
    state = ChangeEmailState.unknown();
    pinController.clear();
    textController.clear();
  }

  void clearFrom() {
    state.userEmailForm.unfocus();
    state.userEmailForm.reset();
    pinController.clear();
    textController.clear();

    state = ChangeEmailState.unknown();
  }

  void updateConfirmCode(String? code) {
    if (code == state.confirmCode || code == null) {
      return;
    }

    final confirmCode = code.trimAll;
    if (confirmCode.isEmpty) return;

    final json = state.toJson();

    state = ChangeEmailState.fromJson({
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
      state = ChangeEmailState.fromJson({
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
    state = ChangeEmailState.fromJson({
      ...json,
      "confirmCodeErrors": "Неверный код".tr(),
    });
    pinController.triggerError();
  }
}
