import 'package:bogge_app/utils/validators/no_special_chars_validator.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:reactive_forms/reactive_forms.dart';

@immutable
class SignUpState {
  static final passwordFieldName = 'password';
  static final emailFieldName = 'email';

  final FormGroup signUpForm;
  final String? confirmCode;
  final String? confirmCodeErrors;

  const SignUpState({
    required this.signUpForm,
    this.confirmCode,
    this.confirmCodeErrors,
  });

  SignUpState.unknown()
    : signUpForm = FormGroup({
        emailFieldName: FormControl<String>(
          validators: [Validators.required, Validators.email],
        ),
        passwordFieldName: FormControl<String>(
          validators: [
            Validators.required,
            Validators.minLength(8),
            Validators.delegate(noSpecialCharsValidator),
          ],
        ),
      }),
      confirmCode = null,
      confirmCodeErrors = null;

  factory SignUpState.fromJson(Map<String, dynamic> json) {
    return SignUpState(
      signUpForm: json["signUpForm"],
      confirmCode: json["confirmCode"],
      confirmCodeErrors: json["confirmCodeErrors"],
    );
  }

  String get passwordField => passwordFieldName;
  String get emailField => emailFieldName;

  Map<String, dynamic> toJson() => {
    "signUpForm": signUpForm,
    "confirmCode": confirmCode,
    "confirmCodeErrors": confirmCodeErrors,
  };

  @override
  String toString() {
    return '{ controls: ${signUpForm.controls}, value: ${signUpForm.value}, errors: ${signUpForm.errors}, confirmCode: $confirmCode, confirmCodeErrors: $confirmCodeErrors }';
  }
}
