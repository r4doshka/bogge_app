// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_workout_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateWorkoutDto _$CreateWorkoutDtoFromJson(Map<String, dynamic> json) =>
    CreateWorkoutDto(
      title: json['title'] as String?,
      distance: (json['distance'] as num).toInt(),
      duration: (json['duration'] as num).toInt(),
      calories: (json['calories'] as num).toInt(),
      steps: (json['steps'] as num).toInt(),
    );

Map<String, dynamic> _$CreateWorkoutDtoToJson(CreateWorkoutDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'distance': instance.distance,
      'duration': instance.duration,
      'calories': instance.calories,
      'steps': instance.steps,
    };
