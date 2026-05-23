import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/ui/screens/authorized/workout/widgets/calories_row.dart';
import 'package:bogge_app/ui/screens/authorized/workout/widgets/distance_row.dart';
import 'package:bogge_app/ui/screens/authorized/workout/widgets/speed_row.dart';
import 'package:bogge_app/ui/screens/authorized/workout/widgets/workout_control_panel.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      bottomSheet: WorkoutControlPanel(
        padding: EdgeInsetsDirectional.only(
          bottom: MediaQuery.of(context).viewPadding.bottom,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpace.ph16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 63.h),
              DistanceRow(),
              AppSpace.h32,
              CaloriesRow(),
              AppSpace.h32,
              SpeedRow(),
            ],
          ),
        ),
      ),
    );
  }
}
