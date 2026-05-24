import 'package:bogge_app/features/ftms/providers/ftms_provider.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_border_radius.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WorkoutSpeedButton extends ConsumerWidget {
  final double speed;
  final bool disabled;

  const WorkoutSpeedButton({
    required this.speed,
    required this.disabled,
    super.key,
  });

  bool _isSelected(double currentSpeed) {
    return (currentSpeed - speed).abs() < 0.05;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    final currentSpeed = ref.watch(
      ftmsProvider.select((s) => s.targetSpeed ?? s.workoutData?.speed ?? 0),
    );

    final isSelected = _isSelected(currentSpeed);

    return PrimaryTextButton(
      text: speed.toInt().toString(),
      height: AppSpace.s44.spMin,
      backgroundColor: isSelected ? palette.primary : palette.primary12,
      textStyle: text_s14_w700_lsm043.copyWith(
        color: isSelected ? palette.white : palette.text,
      ),
      textAlign: TextAlign.center,
      borderRadius: AppBorderRadius.all100,
      padding: EdgeInsetsDirectional.symmetric(
        vertical: AppSpace.s8.h,
        horizontal: AppSpace.s8.w,
      ),
      onPress: disabled
          ? null
          : () async {
              await ref.read(ftmsProvider.notifier).setSpeed(speed);
            },
    );
  }
}
