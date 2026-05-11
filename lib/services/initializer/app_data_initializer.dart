import 'package:bogge_app/features/user/providers/user_provider.dart';
import 'package:bogge_app/services/navigation_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appDataInitializerProvider = Provider<AppDataInitializer>(
  (ref) => AppDataInitializer(ref),
);

class AppDataInitializer {
  final Ref ref;

  AppDataInitializer(this.ref);

  Future<bool> initializeCoreData() async {
    final stopwatch = Stopwatch()..start();

    try {
      final user = await ref.read(userProvider.notifier).getUser();

      if (user == null) {
        final context = ref.read(navigationServiceProvider).layoutContext;
        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Пользователь не найден'.tr())),
          );
        }
        return false;
      }
      return true;
    } catch (e) {
      debugPrint('initializeCoreData load user data error =====>  $e');
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
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('AppDataInitializer error =====>  $e');
      return false;
    }
  }
}
