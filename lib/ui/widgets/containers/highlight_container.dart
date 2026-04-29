import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/utils/color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HighlightContainer extends ConsumerWidget {
  final void Function() onPress;
  final Widget child;
  final Decoration? decoration;
  final Color? highlightColor;
  final BorderRadius? borderRadius;
  final double? height;
  final double? width;
  final EdgeInsetsDirectional? padding;

  const HighlightContainer({
    required this.onPress,
    required this.child,
    this.decoration,
    this.borderRadius,
    this.highlightColor,
    this.height,
    this.width,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: highlightColor ?? palette.text.withSafeOpacity(0.1),
        highlightColor: highlightColor ?? palette.text.withSafeOpacity(0.1),
        onTap: onPress,
        child: Ink(
          height: height,
          width: width,
          padding: padding,
          decoration: decoration,
          child: child,
        ),
      ),
    );
  }
}
