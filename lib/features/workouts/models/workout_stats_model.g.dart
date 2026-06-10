// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutStatsModel _$WorkoutStatsModelFromJson(Map<String, dynamic> json) =>
    WorkoutStatsModel(
      total: (json['total'] as num).toInt(),
      averagePerDay: (json['averagePerDay'] as num).toInt(),
      points: (json['points'] as List<dynamic>)
          .map(
            (e) => WorkoutChartPointModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$WorkoutStatsModelToJson(WorkoutStatsModel instance) =>
    <String, dynamic>{
      'total': instance.total,
      'averagePerDay': instance.averagePerDay,
      'points': instance.points,
    };
