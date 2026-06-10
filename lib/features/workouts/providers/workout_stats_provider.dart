import 'package:bogge_app/features/workouts/api/workout_api.dart';
import 'package:bogge_app/features/workouts/models/workout_stat_params.dart';
import 'package:bogge_app/features/workouts/models/workout_stats_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final workoutStatsProvider =
    FutureProvider.family<WorkoutStatsModel?, WorkoutStatsParams>((
      ref,
      params,
    ) {
      return ref.read(workoutRepository).getStats(params: params);
    });
