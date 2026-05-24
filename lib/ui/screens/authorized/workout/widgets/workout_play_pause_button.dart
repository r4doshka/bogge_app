import 'package:bogge_app/features/ftms/providers/ftms_provider.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_icon_button.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WorkoutPlayPauseButton extends ConsumerWidget {
  const WorkoutPlayPauseButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    final treadmillStatus = ref.watch(
      ftmsProvider.select((s) => s.treadmillStatus),
    );

    final isRunning = treadmillStatus == TreadmillStatus.running;

    return PrimaryIconButton(
      svgPath: isRunning
          ? 'assets/icons/stop-icon.svg'
          : 'assets/icons/play-icon.svg',
      iconWidth: AppSpace.s44.spMin,
      iconHeight: AppSpace.s44.spMin,
      containerHeight: 122.spMin,
      containerWidth: 122.spMin,
      backgroundColor: isRunning ? palette.primary12 : palette.primary60,
      onPress: () async {
        if (isRunning) {
          await ref.read(ftmsProvider.notifier).pauseTreadmill();
        } else {
          await ref.read(ftmsProvider.notifier).startTreadmill();
        }
      },
    );
  }
}
