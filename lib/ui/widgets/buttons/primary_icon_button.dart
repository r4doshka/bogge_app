import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PrimaryIconButton extends StatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
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
