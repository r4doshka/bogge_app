import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/workouts/providers/pagination_workout_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/list_item/workout_list_item.dart';
import 'package:bogge_app/ui/widgets/skeleton/workout_list_item_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:bogge_app/providers/navigation/routers/authorized/authorized_router.gr.dart';

class WorkoutList extends ConsumerWidget {
  final int total;

  const WorkoutList({required this.total, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: total,
      separatorBuilder: (context, index) => AppSpace.h8,
      itemBuilder: (context, index) {
        final asyncWorkout = ref.watch(workoutAtIndexProvider(index));

        return asyncWorkout.when(
          data: (item) {
            return WorkoutListItem(
              item: item,
              onPress: () => context.router.push(WorkoutStatsRoute(item: item)),
            );
          },
          loading: () => const WorkoutListItemSkeleton(),
          error: (_, _) => const SizedBox(),
        );
      },
    );
  }
}
