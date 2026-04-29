import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_border_radius.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProgressLine extends ConsumerWidget {
  final int count;
  final int currentIndex;
  const ProgressLine({super.key, this.currentIndex = 1, this.count = 6});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    List<Widget> children = [];
    for (var i = 1; i <= count; i++) {
      final isActive = i <= currentIndex;
      final isFirst = i == 1;
      final isLast = i == count;

      final child = Container(
        width: AppSpace.s40.w,
        height: AppSpace.s8.h,
        margin: EdgeInsetsDirectional.only(end: 5.w),
        decoration: BoxDecoration(
          color: isActive ? palette.primary : palette.primary12,
          borderRadius: BorderRadius.only(
            topLeft: isFirst ? AppBorderRadius.r16 : Radius.zero,
            bottomLeft: isFirst ? AppBorderRadius.r16 : Radius.zero,
            topRight: isLast ? AppBorderRadius.r16 : Radius.zero,
            bottomRight: isLast ? AppBorderRadius.r16 : Radius.zero,
          ),
        ),
      );
      children.add(child);
    }
    return Row(children: children);
  }
}
