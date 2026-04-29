import 'package:bogge_app/services/storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final androidOptionsProvider = Provider<AndroidOptions>((ref) {
  return const AndroidOptions();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  final storage = ref.read(secureStorageProvider);
  final options = ref.read(androidOptionsProvider);

  return StorageService(storage, options);
});
