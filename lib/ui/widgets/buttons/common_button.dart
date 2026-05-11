import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_border_radius.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/box_shadows.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/spinner.dart';
import 'package:bogge_app/utils/color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CommonButton extends ConsumerWidget {
  final Function()? onPress;
  final bool isLoading;
  final String text;
  final Color? textColor;
  final TextStyle? textStyle;
  final EdgeInsetsDirectional? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final double? spinnerWidth;
  final double? spinnerHeight;
  final double? spinnerStrokeWith;

  const CommonButton({
    required this.text,
    this.onPress,
    this.isLoading = false,
    this.textColor,
    this.textStyle,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.spinnerWidth,
    this.spinnerHeight,
    this.spinnerStrokeWith,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);
    final style = textStyle ?? text_s17_w400_lsm043;

    final bgColor = onPress != null ? palette.white : palette.white30;

    return Material(
      clipBehavior: Clip.hardEdge,
      borderRadius: borderRadius ?? AppBorderRadius.all100,
      color: Colors.transparent,
      child: InkWell(
        highlightColor: palette.text12,
        splashColor: palette.text12,
        onTap: onPress,
        child: Ink(
          padding:
              padding ??
              EdgeInsetsDirectional.symmetric(
                vertical: AppSpace.s14.h,
                horizontal: AppSpace.s16.w,
              ),
          decoration: BoxDecoration(
            color: backgroundColor ?? bgColor,
            borderRadius: borderRadius ?? AppBorderRadius.all100,
            boxShadow: onPress != null ? AppBoxShadows.buttonBoxShadow : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: isLoading
                ? [
                    Spinner(
                      width: spinnerWidth ?? AppSpace.s24,
                      height: spinnerHeight ?? AppSpace.s24,
                      strokeWidth: spinnerStrokeWith ?? 3,
                    ),
                  ]
                : [
                    Text(
                      text,
                      style: style.copyWith(
                        color: onPress == null
                            ? (textColor ?? palette.peach).withSafeOpacity(0.5)
                            : textColor ?? palette.peach,
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
