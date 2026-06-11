import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/apple_health/providers/apple_health_service_provider.dart';
import 'package:bogge_app/features/ftms/helpers/estimate_steps_by_height.dart';
import 'package:bogge_app/features/ftms/providers/ftms_provider.dart';
import 'package:bogge_app/features/user/providers/user_provider.dart';
import 'package:bogge_app/features/workouts/api/workout_api.dart';
import 'package:bogge_app/features/workouts/models/create_workout_dto.dart';
import 'package:bogge_app/features/workouts/models/workout_stat_values.dart';
import 'package:bogge_app/features/workouts/providers/pagination_workout_provider.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/check_button.dart';
import 'package:bogge_app/ui/widgets/lists/stat_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class WorkoutFinishScreen extends ConsumerWidget {
  const WorkoutFinishScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    final lastWorkoutData = ref.watch(
      ftmsProvider.select((s) => s.lastWorkoutData),
    );
    final device = ref.watch(ftmsProvider.select((s) => s.device));
    final user = ref.watch(userProvider);

    final date = toBeginningOfSentenceCase(
      DateFormat('EEEE, d MMMM', 'ru_RU').format(
        DateTime.now().subtract(
          Duration(seconds: lastWorkoutData?.elapsedTime ?? 0),
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpace.ph16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CheckButton(
                    onPress: () async {
                      if (lastWorkoutData == null || user == null) {
                        context.router.pop();
                        return;
                      }

                      final dto = CreateWorkoutDto(
                        title: device?.advName ?? 'Беговая дорожка',
                        distance: ((lastWorkoutData.distance ?? 0) * 1000)
                            .round(),
                        duration: lastWorkoutData.elapsedTime ?? 0,
                        calories: lastWorkoutData.calories ?? 0,
                        steps: estimatedStepsByHeight(
                          heightCm: user.height ?? 170,
                          distance: lastWorkoutData.distance ?? 0,
                        ),
                      );

                      final createdWorkout = await ref
                          .read(workoutRepository)
                          .createWorkout(dto);

                      if (createdWorkout != null) {
                        ref.invalidate(totalWorkoutCountProvider);
                        ref.invalidate(paginatedWorkoutsProvider);

                        try {
                          final synced = await ref
                              .read(appleHealthServiceProvider)
                              .writeWorkout(createdWorkout);

                          debugPrint('Apple Health sync result: $synced');
                        } catch (e, trace) {
                          debugPrint('Apple Health sync error: $e\n$trace');
                        }
                      }

                      if (context.mounted) {
                        context.router.pop();
                      }
                    },
                  ),
                ],
              ),
              AppSpace.h8,
              Text(
                'Статистика'.tr(),
                style: text_s34_w700_ls04.copyWith(color: palette.text),
              ),
              Text(
                date,
                style: text_s14_w400_ls01.copyWith(color: palette.primary),
              ),
              AppSpace.h16,
              if (lastWorkoutData != null && user != null)
                StatList(
                  values: WorkoutStatValues.fromFtms(
                    data: lastWorkoutData,
                    user: user,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
