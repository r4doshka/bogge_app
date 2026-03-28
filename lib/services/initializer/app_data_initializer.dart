import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appDataInitializerProvider = Provider<AppDataInitializer>((ref) {
  return AppDataInitializer();
});

class AppDataInitializer {
  Future<bool> initializeCoreData() async {
    final stopwatch = Stopwatch()..start();

    try {} catch (e) {
      debugPrint('initializeCoreData load user data error =====>  $e');
    }

    try {
      return true;
    } catch (e) {
      debugPrint('initializeCoreData error =====>  $e');
      return false;
    } finally {
      stopwatch.stop();
      debugPrint('initializeCoreData took ${stopwatch.elapsedMilliseconds} ms');
    }
  }

  Future<bool> initializeAdditionalData() async {
    final stopwatch = Stopwatch()..start();
    try {
      return true;
    } catch (e) {
      debugPrint('initializeAdditionalData error =====>  $e');
      return false;
    } finally {
      stopwatch.stop();
      debugPrint(
        'initializeAdditionalData took ${stopwatch.elapsedMilliseconds} ms',
      );
    }
  }

  Future<bool> initialize() async {
    try {
      final initialized = await initializeCoreData();
      if (initialized) {
        await initializeAdditionalData();
      }
      return true;
    } catch (e) {
      debugPrint('AppDataInitializer error =====>  $e');
      return false;
    }
  }
}
