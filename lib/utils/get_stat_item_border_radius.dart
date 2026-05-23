import 'package:flutter/material.dart';
import 'package:bogge_app/ui/ui_tokens/app_border_radius.dart';

BorderRadius getStatItemBorderRadius(bool isLastItem, bool isFirstItem) {
  if (isLastItem && isFirstItem) {
    return const BorderRadius.only(
      topLeft: AppBorderRadius.r24,
      topRight: AppBorderRadius.r24,
      bottomLeft: AppBorderRadius.r24,
      bottomRight: AppBorderRadius.r24,
    );
  }

  if (isFirstItem) {
    return const BorderRadius.only(
      topLeft: AppBorderRadius.r24,
      topRight: AppBorderRadius.r24,
      bottomLeft: Radius.zero,
      bottomRight: Radius.zero,
    );
  }

  if (isLastItem) {
    return const BorderRadius.only(
      topLeft: Radius.zero,
      topRight: Radius.zero,
      bottomLeft: AppBorderRadius.r24,
      bottomRight: AppBorderRadius.r24,
    );
  }

  return BorderRadius.zero;
}
