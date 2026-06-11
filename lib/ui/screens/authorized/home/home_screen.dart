import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/workouts/providers/pagination_workout_provider.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/banners/start_workout_banner.dart';
import 'package:bogge_app/ui/widgets/buttons/bluetooth_button.dart';
import 'package:bogge_app/ui/widgets/buttons/profile_button.dart';
import 'package:bogge_app/ui/widgets/empty_workouts.dart';
import 'package:bogge_app/ui/widgets/lists/workout_list.dart';
import 'package:bogge_app/ui/widgets/skeleton/workout_list_skeleton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpace.ph16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [BluetoothButton(), ProfileButton()],
              ),
              AppSpace.h16,
              StartWorkoutBanner(),
              AppSpace.h24,
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    final asyncData = ref.watch(totalWorkoutCountProvider);

                    return asyncData.when(
                      data: (totalCount) {
                        if (totalCount == 0) {
                          return const Center(child: EmptyWorkouts());
                        }

                        final data = ref.watch(paginatedWorkoutsProvider(0));

                        return data.when(
                          data: (response) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Тренировки'.tr(),
                                  style: text_s34_w700_ls04.copyWith(
                                    color: palette.text,
                                  ),
                                ),
                                AppSpace.h16,
                                Expanded(child: WorkoutList(total: totalCount)),
                              ],
                            );
                          },
                          error: (_, _) => const SizedBox(),
                          loading: () => const WorkoutListSkeleton(),
                        );
                      },
                      error: (error, _) {
                        debugPrint('e $error');
                        return const SizedBox();
                      },
                      loading: () => const WorkoutListSkeleton(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
