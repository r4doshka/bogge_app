import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ModalTitle extends ConsumerWidget {
  final String label;

  const ModalTitle({super.key, required this.label});

  @override
  Widget build(context, ref) {
    final palette = ref.watch(paletteProvider);

    return Text(
      label,
      style: text_s15_w600_lsm043.copyWith(color: palette.text),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }
}
