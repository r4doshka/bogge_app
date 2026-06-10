import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/workouts/models/workout_model.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/list_item/workout_list_item.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:bogge_app/providers/navigation/routers/authorized/authorized_router.gr.dart';

class WorkoutList extends ConsumerWidget {
  final List<WorkoutModel> list;

  const WorkoutList({required this.list, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: list.length,
      separatorBuilder: (context, index) => AppSpace.h8,
      itemBuilder: (context, index) {
        final item = list[index];

        return WorkoutListItem(
          item: item,
          onPress: () => context.router.push(WorkoutStatsRoute(item: item)),
        );
      },
    );
  }
}
