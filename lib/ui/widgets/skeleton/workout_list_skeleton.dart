import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/skeleton/workout_list_item_skeleton.dart';
import 'package:flutter/cupertino.dart';

class WorkoutListSkeleton extends StatelessWidget {
  const WorkoutListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: 9,
      separatorBuilder: (_, _) => AppSpace.h8,
      itemBuilder: (_, _) => const WorkoutListItemSkeleton(),
    );
  }
}
