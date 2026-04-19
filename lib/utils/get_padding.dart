import 'package:flutter/material.dart';

double getPaddingBottom(BuildContext context) {
  return MediaQuery.of(context).padding.bottom;
}

double getPaddingTop(BuildContext context) {
  return MediaQuery.viewPaddingOf(context).top;
}
