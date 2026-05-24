// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_workouts_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedWorkoutsResponse _$PaginatedWorkoutsResponseFromJson(
  Map<String, dynamic> json,
) => PaginatedWorkoutsResponse(
  workouts: (json['workouts'] as List<dynamic>)
      .map((e) => WorkoutModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCount: (json['totalCount'] as num).toInt(),
);

Map<String, dynamic> _$PaginatedWorkoutsResponseToJson(
  PaginatedWorkoutsResponse instance,
) => <String, dynamic>{
  'workouts': instance.workouts,
  'totalCount': instance.totalCount,
};
