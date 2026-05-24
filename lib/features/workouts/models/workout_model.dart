import 'package:bogge_app/features/ftms/helpers/format_distance.dart';
import 'package:json_annotation/json_annotation.dart';

part 'workout_model.g.dart';

@JsonSerializable()
class WorkoutModel {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String? title;

  /// meters
  final int distance;

  /// seconds
  final int duration;

  /// kcal
  final int calories;

  final int steps;

  @JsonKey(name: 'user_id')
  final int userId;

  const WorkoutModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.distance,
    required this.duration,
    required this.calories,
    required this.steps,
    required this.userId,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return _$WorkoutModelFromJson(json);
  }

  String formattedDistance([String locale = 'ru']) {
    return formatDistanceMeters(distance, locale);
  }

  Map<String, dynamic> toJson() => _$WorkoutModelToJson(this);
}
