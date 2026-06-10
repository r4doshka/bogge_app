import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_border_radius.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SlidingSegmentedControl extends ConsumerWidget {
  final List<String> titles;
  final void Function(int index) onValueChanged;
  final int initialValue;
  final int activeIndex;
  final TextStyle? textStyle;
  final double height;
  final bool isDisabled;
  final Color? activeColor;
  final Color? containerColor;
  final BorderRadius? borderRadius;

  const SlidingSegmentedControl({
    super.key,
    required this.titles,
    required this.onValueChanged,
    required this.activeIndex,
    this.initialValue = 0,
    this.textStyle,
    this.height = 26,
    this.isDisabled = false,
    this.activeColor,
    this.containerColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    return CustomSlidingSegmentedControl<int>(
      isDisabled: isDisabled,
      initialValue: initialValue,
      isStretch: true,
      children: _buildChildren(isDisabled: isDisabled),
      padding: 0,
      clipBehavior: Clip.hardEdge,
      innerPadding: EdgeInsets.all(AppSpace.s4.spMin),
      height: height.h,
      customSegmentSettings: CustomSegmentSettings(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      decoration: BoxDecoration(
        color: containerColor ?? palette.gray2,
        borderRadius: borderRadius ?? AppBorderRadius.all100,
        backgroundBlendMode: BlendMode.srcIn,
      ),
      thumbDecoration: BoxDecoration(
        color: activeColor ?? palette.white,
        borderRadius: borderRadius ?? AppBorderRadius.all100,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      onValueChanged: onValueChanged,
    );
  }

  Map<int, Widget> _buildChildren({required bool isDisabled}) {
    return titles
        .asMap()
        .entries
        .map(
          (entry) => _SlidingSegmentedControlItem(
            key: Key(entry.key.toString()),
            text: entry.value,
            isActive: entry.key == activeIndex,
            textStyle: textStyle,
            isDisabled: isDisabled,
          ),
        )
        .toList()
        .asMap();
  }
}

class _SlidingSegmentedControlItem extends ConsumerWidget {
  final String text;
  final bool isActive;
  final TextStyle? textStyle;
  final bool isDisabled;

  const _SlidingSegmentedControlItem({
    super.key,
    required this.text,
    required this.isActive,
    this.textStyle,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    final color = isActive
        ? palette.text
        : isDisabled
        ? palette.text60
        : palette.text;

    return Text(
      text,
      textAlign: TextAlign.center,
      style: textStyle != null
          ? textStyle!.copyWith(color: color)
          : text_s14_w500_lsm043.copyWith(color: color),
    );
  }
}
