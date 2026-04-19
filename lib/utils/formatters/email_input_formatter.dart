import 'package:flutter/services.dart';

class EmailInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;

    text = text.replaceAll(' ', '');

    text = text.toLowerCase();

    text = text.replaceAll(RegExp(r'[^a-z0-9@._\-+]'), '');

    final atCount = '@'.allMatches(text).length;
    if (atCount > 1) {
      return oldValue;
    }

    if (text.contains('@.')) {
      return oldValue;
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
