import 'package:bogge_app/utils/validators/no_special_chars_validator.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:reactive_forms/reactive_forms.dart';

@immutable
class SignInState {
  static final passwordFieldName = 'password';
  static final emailFieldName = 'email';

  final FormGroup signInForm;

  const SignInState({required this.signInForm});

  SignInState.unknown()
    : signInForm = FormGroup({
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
      });

  factory SignInState.fromJson(Map<String, dynamic> json) {
    return SignInState(signInForm: json["signInForm"]);
  }

  String get passwordField => passwordFieldName;
  String get emailField => emailFieldName;

  Map<String, dynamic> toJson() => {"signInForm": signInForm};

  @override
  String toString() {
    return '{ controls: ${signInForm.controls}, value: ${signInForm.value}, errors: ${signInForm.errors} }';
  }
}
