import 'package:json_annotation/json_annotation.dart';

part 'create_workout_dto.g.dart';

@JsonSerializable()
class CreateWorkoutDto {
  final String? title;

  /// meters
  final int distance;

  /// seconds
  final int duration;

  /// kcal
  final int calories;

  final int steps;

  const CreateWorkoutDto({
    required this.title,
    required this.distance,
    required this.duration,
    required this.calories,
    required this.steps,
  });

  factory CreateWorkoutDto.fromJson(Map<String, dynamic> json) {
    return _$CreateWorkoutDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CreateWorkoutDtoToJson(this);
}
