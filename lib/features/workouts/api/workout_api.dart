import 'package:bogge_app/features/auth/api/backend_error_code_parser.dart';
import 'package:bogge_app/features/auth/api/backend_success_code_parser.dart';
import 'package:bogge_app/features/workouts/models/create_workout_dto.dart';
import 'package:bogge_app/features/workouts/models/paginated_workouts_response.dart';
import 'package:bogge_app/features/workouts/models/workout_model.dart';
import 'package:bogge_app/features/workouts/models/workout_stat_params.dart';
import 'package:bogge_app/features/workouts/models/workout_stats_model.dart';
import 'package:bogge_app/services/http/core/http_client_base.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final workoutRepository = Provider<WorkoutRepositoryAPI>(
  (ref) => WorkoutRepositoryAPI(ref),
);

abstract class WorkoutRepository {
  Future<PaginatedWorkoutsResponse> getWorkouts({
    required int max,
    required int offset,
  });
  Future<WorkoutModel?> createWorkout(CreateWorkoutDto dto);
  Future<WorkoutStatsModel?> getStats({required WorkoutStatsParams params});
}

class WorkoutRepositoryAPI implements WorkoutRepository {
  final Ref ref;
  WorkoutRepositoryAPI(this.ref);

  static const String path = "/api/workouts";

  @override
  Future<PaginatedWorkoutsResponse> getWorkouts({
    required int max,
    required int offset,
  }) async {
    final response = await ref
        .read(httpProvider.notifier)
        .get(
          query: '$path?max=$max&offset=$offset',
          type: AuthType.bearer,
          errorMapper: BackendErrorCodeX.fromCode,
          successMapper: AuthSuccessCodeX.fromCode,
        );

    if (!response.success || response.data == null) {
      return const PaginatedWorkoutsResponse(workouts: [], totalCount: 0);
    }

    try {
      final json = response.data as Map<String, dynamic>;

      return PaginatedWorkoutsResponse.fromJson(json);
    } catch (e, trace) {
      debugPrint('getWorkouts error: $e, $trace');

      return const PaginatedWorkoutsResponse(workouts: [], totalCount: 0);
    }
  }

  @override
  Future<WorkoutModel?> createWorkout(CreateWorkoutDto dto) async {
    final response = await ref
        .read(httpProvider.notifier)
        .post(
          query: path,
          data: dto.toJson(),
          type: AuthType.bearer,
          errorMapper: BackendErrorCodeX.fromCode,
          successMapper: AuthSuccessCodeX.fromCode,
        );

    if (!response.success || response.data == null) {
      return null;
    }

    try {
      return WorkoutModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e, trace) {
      debugPrint('createWorkout error: $e, $trace');
      return null;
    }
  }

  @override
  Future<WorkoutStatsModel?> getStats({
    required WorkoutStatsParams params,
  }) async {
    final response = await ref
        .read(httpProvider.notifier)
        .get(
          query:
              '$path/stats?workoutId=${params.workoutId}'
              '&period=${params.period.value}'
              '&type=${params.type.value}',
          type: AuthType.bearer,
          errorMapper: BackendErrorCodeX.fromCode,
          successMapper: AuthSuccessCodeX.fromCode,
        );

    if (!response.success || response.data == null) {
      return null;
    }

    try {
      return WorkoutStatsModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e, trace) {
      debugPrint('getStats error: $e, $trace');

      return null;
    }
  }
}
