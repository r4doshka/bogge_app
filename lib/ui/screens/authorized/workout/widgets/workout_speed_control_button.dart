import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_icon_button.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WorkoutSpeedControlButton extends ConsumerWidget {
  final WorkoutSpeedControlType controlType;
  final Future<void> Function(double) onPress;

  const WorkoutSpeedControlButton({
    required this.controlType,
    required this.onPress,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    return PrimaryIconButton(
      svgPath: controlType.iconPath,
      iconWidth: 18.spMin,
      iconHeight: 18.spMin,
      containerHeight: AppSpace.s44.spMin,
      containerWidth: 100.spMin,
      backgroundColor: palette.primary12,
      onPress: () async {
        HapticFeedback.heavyImpact();
        onPress(0.1);
      },
      onLongPress: () async {
        HapticFeedback.heavyImpact();
        onPress(1);
      },
    );
  }
}
