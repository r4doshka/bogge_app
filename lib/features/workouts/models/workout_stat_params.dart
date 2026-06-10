import 'package:bogge_app/utils/enums.dart';

class WorkoutStatsParams {
  final int workoutId;
  final WorkoutStatsType type;
  final WorkoutStatsPeriod period;

  const WorkoutStatsParams({
    required this.workoutId,
    required this.type,
    required this.period,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WorkoutStatsParams &&
            other.workoutId == workoutId &&
            other.type == type &&
            other.period == period;
  }

  @override
  int get hashCode => Object.hash(workoutId, type, period);
}
