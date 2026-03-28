import 'package:flutter/material.dart';

class ModalTitle extends StatelessWidget {
  final String label;
  const ModalTitle({super.key, required this.label});

  @override
  Widget build(context) {
    return Text(
      label,
      // style: text_s14_w500.copyWith(color: palette.gray1),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }
}
