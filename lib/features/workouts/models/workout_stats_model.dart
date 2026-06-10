import 'package:bogge_app/features/workouts/models/workout_chart_point_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'workout_stats_model.g.dart';

@JsonSerializable()
class WorkoutStatsModel {
  final int total;
  final int averagePerDay;
  final List<WorkoutChartPointModel> points;

  const WorkoutStatsModel({
    required this.total,
    required this.averagePerDay,
    required this.points,
  });

  factory WorkoutStatsModel.fromJson(Map<String, dynamic> json) {
    return _$WorkoutStatsModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$WorkoutStatsModelToJson(this);
  }
}
