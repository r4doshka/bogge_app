import 'dart:io';

import 'package:bogge_app/features/workouts/models/workout_model.dart';
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';

class AppleHealthService {
  final Health _health = Health();

  static const _types = [
    HealthDataType.WORKOUT,
    HealthDataType.STEPS,
    HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.ACTIVE_ENERGY_BURNED,
  ];

  static const _permissions = [
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
    HealthDataAccess.READ_WRITE,
  ];

  Future<bool> requestPermissions() async {
    if (!Platform.isIOS) return false;

    await _health.configure();

    return _health.requestAuthorization(_types, permissions: _permissions);
  }

  Future<bool> writeWorkout(WorkoutModel workout) async {
    if (!Platform.isIOS) return false;

    try {
      final granted = await requestPermissions();

      if (!granted) {
        return false;
      }

      final start = workout.createdAt;
      final end = start.add(Duration(seconds: workout.duration));

      if (!end.isAfter(start)) {
        return false;
      }

      final workoutSuccess = await _health.writeWorkoutData(
        activityType: HealthWorkoutActivityType.WALKING,
        start: start,
        end: end,
        totalEnergyBurned: workout.calories,
        totalEnergyBurnedUnit: HealthDataUnit.KILOCALORIE,
        totalDistance: workout.distance,
        totalDistanceUnit: HealthDataUnit.METER,
        title: workout.title ?? 'Workout',
        recordingMethod: RecordingMethod.manual,
      );

      final dataResults = await Future.wait([
        _health.writeHealthData(
          value: workout.steps.toDouble(),
          type: HealthDataType.STEPS,
          startTime: start,
          endTime: end,
          recordingMethod: RecordingMethod.manual,
        ),
        _health.writeHealthData(
          value: workout.distance.toDouble(),
          type: HealthDataType.DISTANCE_WALKING_RUNNING,
          startTime: start,
          endTime: end,
          recordingMethod: RecordingMethod.manual,
        ),
        _health.writeHealthData(
          value: workout.calories.toDouble(),
          type: HealthDataType.ACTIVE_ENERGY_BURNED,
          startTime: start,
          endTime: end,
          recordingMethod: RecordingMethod.manual,
        ),
      ]);

      return workoutSuccess && dataResults.every((e) => e);
    } catch (e, trace) {
      debugPrint('Apple Health writeWorkout error: $e\n$trace');
      return false;
    }
  }
}
