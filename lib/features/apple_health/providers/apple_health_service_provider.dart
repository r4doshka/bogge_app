import 'package:bogge_app/features/apple_health/apple_health_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appleHealthServiceProvider = Provider<AppleHealthService>((ref) {
  return AppleHealthService();
});
