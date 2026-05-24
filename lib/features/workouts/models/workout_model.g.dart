// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutModel _$WorkoutModelFromJson(Map<String, dynamic> json) => WorkoutModel(
  id: (json['id'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  title: json['title'] as String?,
  distance: (json['distance'] as num).toInt(),
  duration: (json['duration'] as num).toInt(),
  calories: (json['calories'] as num).toInt(),
  steps: (json['steps'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
);

Map<String, dynamic> _$WorkoutModelToJson(WorkoutModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'title': instance.title,
      'distance': instance.distance,
      'duration': instance.duration,
      'calories': instance.calories,
      'steps': instance.steps,
      'user_id': instance.userId,
    };
