import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PrimaryTextButton extends ConsumerWidget {
  final String text;
  final TextStyle? textStyle;
  final Color? textColor;
  final Function()? onPress;
  final EdgeInsetsDirectional? padding;
  final Color backgroundColor;

  const PrimaryTextButton({
    super.key,
    required this.text,
    required this.onPress,
    this.textStyle,
    this.textColor,
    this.padding,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);

    final textStyles =
        textStyle ??
        text_s14_w700_ls01.copyWith(color: textColor ?? palette.text60);

    return Opacity(
      opacity: onPress == null ? 0.8 : 1,
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.zero,
        child: InkWell(
          onTap: onPress,
          child: Ink(
            padding:
                padding ??
                EdgeInsetsDirectional.symmetric(
                  vertical: AppSpace.s2.h,
                  horizontal: AppSpace.s4.w,
                ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.zero,
            ),
            child: Text(text, style: textStyles),
          ),
        ),
      ),
    );
  }
}
