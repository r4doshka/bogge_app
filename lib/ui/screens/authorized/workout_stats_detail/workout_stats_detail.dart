import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/workouts/models/workout_stat_params.dart';
import 'package:bogge_app/features/workouts/models/workout_stat_values.dart';
import 'package:bogge_app/features/workouts/providers/workout_stats_provider.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/charts/workout_stats_chart.dart';
import 'package:bogge_app/ui/widgets/headers/common_header.dart';
import 'package:bogge_app/ui/widgets/skeleton/workout_stat_card_skeleton.dart';
import 'package:bogge_app/ui/widgets/sliding_segmented_control.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class WorkoutStatsDetailScreen extends HookConsumerWidget {
  final WorkoutStatsType type;
  final int workoutId;

  const WorkoutStatsDetailScreen({
    required this.type,
    required this.workoutId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);
    final period = useState(WorkoutStatsPeriod.day);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpace.ph16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonHeader(),
              AppSpace.h8,
              Text(
                type.title.tr(),
                style: text_s34_w700_ls04.copyWith(color: palette.text),
              ),
              Text(
                period.value.title.tr(),
                style: text_s14_w400_ls01.copyWith(color: palette.primary),
              ),
              AppSpace.h16,
              SlidingSegmentedControl(
                titles: WorkoutStatsPeriod.titleList,
                onValueChanged: (value) =>
                    period.value = WorkoutStatsPeriod.values[value],
                activeIndex: period.value.index,
              ),
              AppSpace.h16,
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  color: palette.white,
                ),
                padding: EdgeInsetsDirectional.symmetric(
                  vertical: AppSpace.s16.h,
                  horizontal: AppSpace.s16.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      period.value.description.tr(),
                      style: text_s17_w600_lsm043.copyWith(color: palette.text),
                    ),
                    AppSpace.h4,

                    Consumer(
                      builder: (context, ref, _) {
                        final asyncStats = ref.watch(
                          workoutStatsProvider(
                            WorkoutStatsParams(
                              workoutId: workoutId,
                              type: type,
                              period: period.value,
                            ),
                          ),
                        );

                        return asyncStats.when(
                          data: (data) {
                            if (data == null) {
                              return const SizedBox();
                            }

                            final value = period.value == WorkoutStatsPeriod.day
                                ? data.total
                                : data.averagePerDay;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  WorkoutStatValues.formatStat(
                                    type: type,
                                    value: value,
                                  ),
                                  style: text_s28_w600_lsm043.copyWith(
                                    color: palette.primary,
                                  ),
                                ),
                                AppSpace.h4,
                                WorkoutStatsChart(data: data),
                              ],
                            );
                          },
                          loading: () => const WorkoutStatsCardSkeleton(),
                          error: (_, _) => const SizedBox(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
