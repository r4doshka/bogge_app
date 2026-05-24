import 'package:bogge_app/features/ftms/models/ftms_data.dart';
import 'package:bogge_app/features/user/models/user_model.dart';
import 'package:bogge_app/features/workouts/models/workout_model.dart';
import 'package:bogge_app/utils/enums.dart';

class WorkoutStatValues {
  final String steps;
  final String duration;
  final String calories;
  final String distance;

  const WorkoutStatValues({
    required this.steps,
    required this.duration,
    required this.calories,
    required this.distance,
  });

  factory WorkoutStatValues.fromFtms({
    required FtmsData data,
    required UserModel user,
  }) {
    return WorkoutStatValues(
      steps: data.formattedSteps(
        heightCm: user.height ?? 0,
        distance: data.distance ?? 0,
      ),
      duration: data.formattedDuration,
      calories: data.formattedCalories,
      distance: data.formattedDistance(),
    );
  }

  factory WorkoutStatValues.fromWorkout(WorkoutModel data) {
    return WorkoutStatValues(
      steps: data.steps.toString(),
      duration: formatWorkoutDuration(data.duration),
      calories: data.calories.toString(),
      distance: data.formattedDistance(),
    );
  }

  String getValue(WorkoutStatType type) {
    switch (type) {
      case WorkoutStatType.steps:
        return steps;
      case WorkoutStatType.duration:
        return duration;
      case WorkoutStatType.calories:
        return calories;
      case WorkoutStatType.distance:
        return distance;
    }
  }

  static String formatWorkoutDuration(int seconds) {
    final duration = Duration(seconds: seconds);

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final secs = duration.inSeconds.remainder(60);

    final parts = <String>[];

    if (hours > 0) {
      parts.add('$hours ч');
    }

    if (minutes > 0) {
      parts.add('$minutes мин');
    }

    if (secs > 0 || parts.isEmpty) {
      parts.add('$secs сек');
    }

    return parts.join(' ');
  }
}
