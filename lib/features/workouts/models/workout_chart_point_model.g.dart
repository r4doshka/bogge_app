// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_chart_point_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutChartPointModel _$WorkoutChartPointModelFromJson(
  Map<String, dynamic> json,
) => WorkoutChartPointModel(
  label: json['label'] as String,
  tooltipLabel: json['tooltipLabel'] as String,
  value: (json['value'] as num).toInt(),
);

Map<String, dynamic> _$WorkoutChartPointModelToJson(
  WorkoutChartPointModel instance,
) => <String, dynamic>{
  'label': instance.label,
  'tooltipLabel': instance.tooltipLabel,
  'value': instance.value,
};
