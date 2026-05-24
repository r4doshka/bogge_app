import 'package:bogge_app/features/ftms/providers/ftms_provider.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WorkoutTimerView extends ConsumerWidget {
  const WorkoutTimerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    final time = ref.watch(
      ftmsProvider.select((s) => s.workoutData?.formattedElapsedTime()),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/icons/timer-icon.svg',
          width: AppSpace.s44.spMin,
          height: AppSpace.s44.spMin,
        ),
        AppSpace.w16,
        Container(
          constraints: BoxConstraints(minWidth: 225.w),
          child: Text(
            time ?? '00:00,00',
            style: text_s48_w900_lsm043.copyWith(color: palette.primary),
          ),
        ),
      ],
    );
  }
}
