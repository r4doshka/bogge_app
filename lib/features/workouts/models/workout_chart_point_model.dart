import 'package:json_annotation/json_annotation.dart';

part 'workout_chart_point_model.g.dart';

@JsonSerializable()
class WorkoutChartPointModel {
  final String label;
  final String tooltipLabel;
  final int value;

  const WorkoutChartPointModel({
    required this.label,
    required this.tooltipLabel,
    required this.value,
  });

  factory WorkoutChartPointModel.fromJson(Map<String, dynamic> json) {
    return _$WorkoutChartPointModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$WorkoutChartPointModelToJson(this);
  }
}
