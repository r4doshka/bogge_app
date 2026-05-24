import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/ftms/providers/ftms_provider.dart';
import 'package:bogge_app/providers/navigation/routers/authorized/authorized_router.gr.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/screens/authorized/workout/widgets/workout_action_button.dart';
import 'package:bogge_app/ui/screens/authorized/workout/widgets/workout_play_pause_button.dart';
import 'package:bogge_app/ui/screens/authorized/workout/widgets/workout_speed_button.dart';
import 'package:bogge_app/ui/screens/authorized/workout/widgets/workout_speed_control_button.dart';
import 'package:bogge_app/ui/screens/authorized/workout/widgets/workout_speed_view.dart';
import 'package:bogge_app/ui/screens/authorized/workout/widgets/workout_timer_view.dart';
import 'package:bogge_app/ui/ui_tokens/app_border_radius.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/form/custom_swipe_switch.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WorkoutControlPanel extends HookConsumerWidget {
  final EdgeInsetsDirectional? padding;

  const WorkoutControlPanel({this.padding, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);
    final isBlocked = useState(false);
    final isExpanded = useState(false);

    void handleVerticalDragEnd(DragEndDetails details) {
      final velocity = details.primaryVelocity ?? 0;

      if (velocity < -250) {
        isExpanded.value = true;
      }

      if (velocity > 250) {
        isExpanded.value = false;
      }
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragEnd: handleVerticalDragEnd,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        alignment: Alignment.topCenter,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(38),
              topRight: Radius.circular(38),
            ),
            color: palette.white,
          ),
          child: Padding(
            padding: AppSpace.ph16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    height: 5.h,
                    width: AppSpace.s36.w,
                    margin: EdgeInsetsDirectional.only(top: 5.h),
                    decoration: BoxDecoration(
                      borderRadius: AppBorderRadius.all16,
                      color: palette.text30,
                    ),
                  ),
                ),
                AppSpace.h16,
                const WorkoutTimerView(),
                AppSpace.h20,

                if (isBlocked.value)
                  CustomSwipeSwitch(
                    value: isBlocked.value,
                    onChange: (val) => isBlocked.value = val,
                  ),

                if (!isBlocked.value) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WorkoutActionButton(
                        svgPath: 'assets/icons/cross1-icon.svg',
                        title: 'Завершить'.tr(),
                        onPress: () async {
                          final notifier = ref.read(ftmsProvider.notifier);

                          notifier.saveLastWorkoutData();

                          await notifier.stopTreadmill();

                          if (context.mounted) {
                            context.router.replace(WorkoutFinishRoute());
                          }
                        },
                      ),
                      const WorkoutPlayPauseButton(),
                      WorkoutActionButton(
                        svgPath: 'assets/icons/lock-icon.svg',
                        title: 'Блокировка'.tr(),
                        onPress: () async {
                          isBlocked.value = true;
                        },
                      ),
                    ],
                  ),

                  if (isExpanded.value) ...[
                    AppSpace.h32,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WorkoutSpeedControlButton(
                          controlType: WorkoutSpeedControlType.decrease,
                          onPress: (step) async {
                            await ref
                                .read(ftmsProvider.notifier)
                                .decreaseSpeed(step: step);
                          },
                        ),
                        const WorkoutSpeedView(),
                        WorkoutSpeedControlButton(
                          controlType: WorkoutSpeedControlType.increase,
                          onPress: (step) async {
                            await ref
                                .read(ftmsProvider.notifier)
                                .increaseSpeed(step: step);
                          },
                        ),
                      ],
                    ),
                    AppSpace.h16,
                    Row(
                      children: [
                        Expanded(child: WorkoutSpeedButton(speed: 4)),
                        AppSpace.w20,
                        Expanded(child: WorkoutSpeedButton(speed: 7)),
                        AppSpace.w20,
                        Expanded(child: WorkoutSpeedButton(speed: 10)),
                      ],
                    ),
                  ],
                ],

                AppSpace.h12,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
