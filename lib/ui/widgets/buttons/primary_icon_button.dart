import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/utils/color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PrimaryIconButton extends ConsumerWidget {
  final String svgPath;
  final Color? svgColor;
  final double? iconWidth;
  final double? iconHeight;
  final double? containerWidth;
  final double? containerHeight;
  final BorderRadius? borderRadius;
  final void Function()? onPress;
  final Color backgroundColor;
  final bool matchTextDirection;
  final BoxBorder? border;
  final EdgeInsetsDirectional? padding;
  final Color? highlightColor;

  const PrimaryIconButton({
    super.key,
    required this.svgPath,
    this.onPress,
    this.iconWidth = 24,
    this.iconHeight = 24,
    this.containerWidth = 24,
    this.containerHeight = 24,
    this.backgroundColor = Colors.transparent,
    this.svgColor,
    this.matchTextDirection = false,
    this.border,
    this.padding,
    this.borderRadius,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    return Material(
      borderRadius:
          borderRadius ??
          (containerWidth != null
              ? BorderRadius.all(Radius.circular(containerWidth! / 2))
              : null),
      color: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onPress,
        splashColor: highlightColor ?? palette.text.withSafeOpacity(0.1),
        highlightColor: highlightColor ?? palette.text.withSafeOpacity(0.1),
        child: Ink(
          padding: padding,
          width: containerWidth,
          height: containerHeight,
          decoration: BoxDecoration(
            border: border,
            color: backgroundColor,
            borderRadius:
                borderRadius ??
                (containerWidth != null
                    ? BorderRadius.all(Radius.circular(containerWidth! / 2))
                    : null),
          ),
          child: Center(
            child: SizedBox(
              width: iconWidth,
              height: iconHeight,
              child: SvgPicture.asset(
                svgPath,
                height: iconHeight,
                width: iconWidth,
                matchTextDirection: matchTextDirection,
                colorFilter: svgColor != null
                    ? ColorFilter.mode(svgColor!, BlendMode.srcIn)
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
