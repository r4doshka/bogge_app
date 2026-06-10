import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/workouts/models/workout_model.dart';
import 'package:bogge_app/features/workouts/models/workout_stat_values.dart';
import 'package:bogge_app/providers/navigation/routers/authorized/authorized_router.gr.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/headers/common_header.dart';
import 'package:bogge_app/ui/widgets/lists/stat_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class WorkoutStatsScreen extends ConsumerWidget {
  final WorkoutModel item;

  const WorkoutStatsScreen({required this.item, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);
    final date = toBeginningOfSentenceCase(
      DateFormat('EEEE, d MMMM', 'ru_RU').format(item.createdAt),
    );
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
                'Статистика'.tr(),
                style: text_s34_w700_ls04.copyWith(color: palette.text),
              ),
              Text(
                date,
                style: text_s14_w400_ls01.copyWith(color: palette.primary),
              ),
              AppSpace.h16,
              StatList(
                values: WorkoutStatValues.fromWorkout(item),
                onPress: (type) => context.router.push(
                  WorkoutStatsDetailRoute(type: type, workoutId: item.id),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
