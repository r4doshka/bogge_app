import 'package:bogge_app/features/workouts/api/workout_api.dart';
import 'package:bogge_app/features/workouts/models/paginated_workouts_response.dart';
import 'package:bogge_app/features/workouts/models/workout_model.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const workoutMax = 15;

final paginatedWorkoutsProvider = FutureProvider.autoDispose
    .family<PaginatedWorkoutsResponse, int>((ref, page) async {
      try {
        final api = ref.read(workoutRepository);
        final response = await api.getWorkouts(
          max: workoutMax,
          offset: page * workoutMax,
        );

        return response;
      } catch (e) {
        debugPrint('paginatedWorkoutsProvider error $e');
        return PaginatedWorkoutsResponse(workouts: [], totalCount: 0);
      }
    }, dependencies: [workoutRepository]);

final totalWorkoutCountProvider = Provider.autoDispose<AsyncValue<int>>((ref) {
  return ref.watch(paginatedWorkoutsProvider(0)).whenData((e) => e.totalCount);
}, dependencies: [paginatedWorkoutsProvider]);

final workoutAtIndexProvider = Provider.autoDispose
    .family<AsyncValue<WorkoutModel>, int>((ref, index) {
      final page = index ~/ workoutMax;
      final indexOnPage = index % workoutMax;

      final res = ref.watch(paginatedWorkoutsProvider(page));

      return res.whenData((e) {
        if (indexOnPage >= e.workouts.length) {
          throw StateError('Workout index out of range');
        }

        return e.workouts[indexOnPage];
      });
    }, dependencies: [paginatedWorkoutsProvider]);
