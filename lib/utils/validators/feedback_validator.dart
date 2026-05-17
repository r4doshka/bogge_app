import 'package:reactive_forms/reactive_forms.dart';

Map<String, dynamic>? feedbackTextValidator(AbstractControl<dynamic> control) {
  final value = control.value?.toString().trim() ?? '';

  if (value.isEmpty) return null;

  final regex = RegExp(r'^[a-zA-Zа-яА-ЯёЁ0-9\s.,!?():;@%+\-_#/&"]+$');

  if (!regex.hasMatch(value)) {
    return {'invalidCharacters': true};
  }

  return null;
}
