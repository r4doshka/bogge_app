import 'package:bogge_app/features/workouts/models/workout_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paginated_workouts_response.g.dart';

@JsonSerializable()
class PaginatedWorkoutsResponse {
  final List<WorkoutModel> workouts;
  final int totalCount;

  const PaginatedWorkoutsResponse({
    required this.workouts,
    required this.totalCount,
  });

  factory PaginatedWorkoutsResponse.fromJson(Map<String, dynamic> json) {
    return _$PaginatedWorkoutsResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PaginatedWorkoutsResponseToJson(this);
}
