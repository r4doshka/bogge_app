import 'package:flutter/foundation.dart' show immutable;
import 'package:reactive_forms/reactive_forms.dart';

@immutable
class SignInState {
  static final passwordFieldName = 'password';
  static final emailFieldName = 'email';

  final bool submitted;
  final FormGroup signInForm;

  const SignInState({required this.signInForm, this.submitted = false});

  SignInState.unknown()
    : signInForm = FormGroup({
        emailFieldName: FormControl<String>(),
        passwordFieldName: FormControl<String>(),
      }),
      submitted = false;

  factory SignInState.fromJson(Map<String, dynamic> json) {
    return SignInState(
      signInForm: json["signInForm"],
      submitted: json["submitted"],
    );
  }

  String get passwordField => passwordFieldName;
  String get emailField => emailFieldName;

  Map<String, dynamic> toJson() => {
    "signInForm": signInForm,
    "submitted": submitted,
  };

  @override
  String toString() {
    return '{ controls: ${signInForm.controls}, value: ${signInForm.value}, errors: ${signInForm.errors}, submitted: $submitted }';
  }
}
