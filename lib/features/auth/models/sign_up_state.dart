import 'package:bogge_app/utils/validators/no_special_chars_validator.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:reactive_forms/reactive_forms.dart';

@immutable
class SignUpState {
  static final passwordFieldName = 'password';
  static final emailFieldName = 'email';

  final bool submitted;
  final FormGroup signUpForm;

  const SignUpState({required this.signUpForm, this.submitted = false});

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
      submitted = false;

  factory SignUpState.fromJson(Map<String, dynamic> json) {
    return SignUpState(
      signUpForm: json["signUpForm"],
      submitted: json["submitted"],
    );
  }

  String get passwordField => passwordFieldName;
  String get emailField => emailFieldName;

  Map<String, dynamic> toJson() => {
    "signUpForm": signUpForm,
    "submitted": submitted,
  };

  @override
  String toString() {
    return '{ controls: ${signUpForm.controls}, value: ${signUpForm.value}, errors: ${signUpForm.errors}, submitted: $submitted }';
  }
}
