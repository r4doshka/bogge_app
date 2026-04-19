import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TextButtonWithIcon extends ConsumerWidget {
  final Widget Function()? renderIconLeft;
  final Widget Function()? renderIconRight;
  final Widget Function()? renderText;
  final String? text;
  final TextStyle? textStyle;
  final Function()? onPress;
  final double? containerWidth;
  final EdgeInsetsDirectional? padding;
  final Color backgroundColor;
  final BorderRadius? borderRadius;
  final bool isLoading;

  const TextButtonWithIcon({
    this.onPress,
    this.text,
    this.renderIconLeft,
    this.renderIconRight,
    this.renderText,
    this.textStyle,
    this.containerWidth,
    this.padding,
    this.backgroundColor = Colors.transparent,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);

    final style =
        textStyle ?? text_s17_w500_lsm043.copyWith(color: palette.text60);
    final currentContainerWidth = containerWidth ?? AppSpace.s24.w;

    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: isLoading ? null : onPress,
        child: Ink(
          padding: padding,
          width: (text != null || renderText != null)
              ? null
              : currentContainerWidth,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (renderIconLeft != null) renderIconLeft!(),
              if (renderText != null) renderText!(),
              if (text != null) Text(text!, style: style),
              if (renderIconRight != null) renderIconRight!(),
            ],
          ),
        ),
      ),
    );
  }
}
