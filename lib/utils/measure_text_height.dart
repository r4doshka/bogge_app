import 'package:flutter/material.dart';

double measureTextHeight(String text, TextStyle style) {
  final textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    maxLines: 1,
  )..layout();

  return textPainter.height;
}
