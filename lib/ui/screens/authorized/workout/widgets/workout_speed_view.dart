import 'package:bogge_app/features/ftms/providers/ftms_provider.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WorkoutSpeedView extends ConsumerWidget {
  const WorkoutSpeedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    final speed = ref.watch(
      ftmsProvider.select((s) {
        final value = s.targetSpeed ?? s.workoutData?.speed ?? 0;

        return value.toStringAsFixed(1);
      }),
    );

    return Column(
      children: [
        Text(
          speed,
          style: text_s48_w900_lsm043.copyWith(color: palette.primary),
        ),
        AppSpace.h4,
        Text(
          'Км/ч'.tr(),
          style: text_s14_w400_ls01.copyWith(color: palette.text30),
        ),
      ],
    );
  }
}
