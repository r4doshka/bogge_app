import 'package:bogge_app/utils/validators/no_special_chars_validator.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:reactive_forms/reactive_forms.dart';

@immutable
class ResetPasswordState {
  static final firstPasswordFieldName = 'password1';
  static final secondPasswordFieldName = 'password2';
  static final emailFieldName = 'email';

  final FormGroup resetPasswordForm;
  final FormGroup createNewPasswordForm;
  final String? confirmCode;
  final String? confirmCodeErrors;

  const ResetPasswordState({
    required this.resetPasswordForm,
    required this.createNewPasswordForm,
    this.confirmCode,
    this.confirmCodeErrors,
  });

  ResetPasswordState.unknown()
    : resetPasswordForm = FormGroup({
        emailFieldName: FormControl<String>(
          validators: [Validators.required, Validators.email],
        ),
      }),
      createNewPasswordForm = FormGroup(
        {
          firstPasswordFieldName: FormControl<String>(
            validators: [
              Validators.required,
              Validators.minLength(8),
              Validators.delegate(noSpecialCharsValidator),
            ],
          ),
          secondPasswordFieldName: FormControl<String>(
            validators: [
              Validators.required,
              Validators.minLength(8),
              Validators.delegate(noSpecialCharsValidator),
            ],
          ),
        },
        validators: [Validators.delegate(passwordsMatchValidator)],
      ),
      confirmCode = null,
      confirmCodeErrors = null;

  factory ResetPasswordState.fromJson(Map<String, dynamic> json) {
    return ResetPasswordState(
      resetPasswordForm: json["resetPasswordForm"],
      createNewPasswordForm: json["createNewPasswordForm"],
      confirmCode: json["confirmCode"],
      confirmCodeErrors: json["confirmCodeErrors"],
    );
  }

  static Map<String, dynamic>? passwordsMatchValidator(
    AbstractControl<dynamic> control,
  ) {
    final form = control as FormGroup;

    final password = form
        .control(ResetPasswordState.firstPasswordFieldName)
        .value;
    final confirm = form
        .control(ResetPasswordState.secondPasswordFieldName)
        .value;

    if (password != confirm) {
      return {'passwordsNotMatch': true};
    }

    return null;
  }

  String get firstPasswordField => firstPasswordFieldName;
  String get secondPasswordField => secondPasswordFieldName;
  String get emailField => emailFieldName;

  Map<String, dynamic> toJson() => {
    "resetPasswordForm": resetPasswordForm,
    "createNewPasswordForm": createNewPasswordForm,
    "confirmCode": confirmCode,
    "confirmCodeErrors": confirmCodeErrors,
  };

  @override
  String toString() {
    return '{ controls: ${resetPasswordForm.controls}, value: ${resetPasswordForm.value}, errors: ${resetPasswordForm.errors}, confirmCode: $confirmCode, confirmCodeErrors: $confirmCodeErrors }';
  }
}
