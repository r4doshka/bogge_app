import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/skeleton/workout_chart_skeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WorkoutStatsCardSkeleton extends StatelessWidget {
  const WorkoutStatsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('12.34 km'),
          AppSpace.h4,
          const WorkoutFullChartSkeleton(),
        ],
      ),
    );
  }
}
