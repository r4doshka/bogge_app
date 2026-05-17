import 'package:flutter/foundation.dart' show immutable;
import 'package:reactive_forms/reactive_forms.dart';

@immutable
class ChangeEmailState {
  static final emailFieldName = 'email';

  final FormGroup userEmailForm;
  final String? confirmCode;
  final String? confirmCodeErrors;

  const ChangeEmailState({
    required this.userEmailForm,
    this.confirmCode,
    this.confirmCodeErrors,
  });

  ChangeEmailState.unknown()
    : userEmailForm = FormGroup({
        emailFieldName: FormControl<String>(
          validators: [Validators.required, Validators.email],
        ),
      }),

      confirmCode = null,
      confirmCodeErrors = null;

  factory ChangeEmailState.fromJson(Map<String, dynamic> json) {
    return ChangeEmailState(
      userEmailForm: json["userEmailForm"],
      confirmCode: json["confirmCode"],
      confirmCodeErrors: json["confirmCodeErrors"],
    );
  }

  String get emailField => emailFieldName;

  Map<String, dynamic> toJson() => {
    "userEmailForm": userEmailForm,
    "confirmCode": confirmCode,
    "confirmCodeErrors": confirmCodeErrors,
  };

  @override
  String toString() {
    return '{ controls: ${userEmailForm.controls}, value: ${userEmailForm.value}, errors: ${userEmailForm.errors}, confirmCode: $confirmCode, confirmCodeErrors: $confirmCodeErrors }';
  }
}
