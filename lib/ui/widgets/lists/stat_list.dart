import 'package:bogge_app/ui/widgets/list_item/statistic_list_item.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:bogge_app/utils/get_stat_item_border_radius.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StatList extends ConsumerWidget {
  const StatList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: WorkoutStatType.values.length,
      itemBuilder: (context, index) {
        final item = WorkoutStatType.values[index];

        final isLast = WorkoutStatType.values.length - 1 == index;
        final isFirst = index == 0;

        final borderRadius = getStatItemBorderRadius(isLast, isFirst);

        return StatisticListItem(
          item: item,
          borderRadius: borderRadius,
          isLast: isLast,
          value: item.unit,
          onPress: () {},
        );
      },
    );
  }
}
