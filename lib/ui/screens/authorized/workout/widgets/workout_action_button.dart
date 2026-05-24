import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WorkoutActionButton extends ConsumerWidget {
  final String svgPath;
  final String title;
  final Future<void> Function()? onPress;

  const WorkoutActionButton({
    required this.svgPath,
    required this.title,
    required this.onPress,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    return Column(
      children: [
        SizedBox(height: 7.h),
        PrimaryIconButton(
          svgPath: svgPath,
          iconWidth: AppSpace.s44.spMin,
          iconHeight: AppSpace.s44.spMin,
          containerHeight: 84.spMin,
          containerWidth: 84.spMin,
          backgroundColor: palette.primary12,
          onPress: onPress,
        ),
        AppSpace.h4,
        Text(title, style: text_s14_w400_ls01.copyWith(color: palette.text30)),
      ],
    );
  }
}
