import 'package:flutter/services.dart';

class EmailInputFormatter extends TextInputFormatter {
  static final _allowed = RegExp(r'[a-z0-9@._\-+]');

  String _format(String value) {
    return value
        .replaceAll(' ', '')
        .toLowerCase()
        .split('')
        .where((char) => _allowed.hasMatch(char))
        .join();
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formattedText = _format(newValue.text);

    final atCount = '@'.allMatches(formattedText).length;
    if (atCount > 1) {
      return oldValue;
    }

    if (formattedText.contains('@.')) {
      return oldValue;
    }

    final cursorText = newValue.text.substring(
      0,
      newValue.selection.end.clamp(0, newValue.text.length),
    );

    final formattedCursorText = _format(cursorText);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedCursorText.length),
      composing: TextRange.empty,
    );
  }
}
