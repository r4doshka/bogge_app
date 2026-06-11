import 'dart:async';

import 'package:bogge_app/features/ftms/providers/ftms_provider.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WorkoutTimerView extends HookConsumerWidget {
  const WorkoutTimerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    final elapsedSeconds = ref.watch(
      ftmsProvider.select((s) => s.workoutData?.elapsedTime ?? 0),
    );

    final tick = useState(0);

    useEffect(() {
      final timer = Timer.periodic(
        const Duration(milliseconds: 100),
        (_) => tick.value++,
      );

      return timer.cancel;
    }, const []);

    final duration = Duration(seconds: elapsedSeconds);

    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    final milliseconds = ((tick.value % 10) * 10).toString().padLeft(2, '0');

    final time = '$minutes:$seconds,$milliseconds';

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
            time,
            style: text_s48_w900_lsm043.copyWith(color: palette.primary),
          ),
        ),
      ],
    );
  }
}
