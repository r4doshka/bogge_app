import 'package:reactive_forms/reactive_forms.dart';

Map<String, dynamic>? noSpecialCharsValidator(
  AbstractControl<dynamic> control,
) {
  final value = control.value as String?;

  if (value == null || value.isEmpty) return null;

  final isValid = RegExp(r'^[a-zA-Z0-9]*$').hasMatch(value);

  return isValid ? null : {'noSpecialChars': true};
}
