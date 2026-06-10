import 'package:bogge_app/features/workouts/models/workout_stat_values.dart';
import 'package:bogge_app/ui/widgets/list_item/statistic_list_item.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:bogge_app/utils/get_stat_item_border_radius.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StatList extends ConsumerWidget {
  final WorkoutStatValues values;
  final void Function(WorkoutStatsType)? onPress;

  const StatList({required this.values, this.onPress, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: WorkoutStatsType.values.length,
      itemBuilder: (context, index) {
        final item = WorkoutStatsType.values[index];

        final isLast = WorkoutStatsType.values.length - 1 == index;
        final isFirst = index == 0;

        final borderRadius = getStatItemBorderRadius(isLast, isFirst);

        final value = values.getValue(item);

        return StatisticListItem(
          item: item,
          borderRadius: borderRadius,
          isLast: isLast,
          value: '$value ${item.unit}'.trim(),
          onPress: onPress != null ? () => onPress!(item) : null,
        );
      },
    );
  }
}
