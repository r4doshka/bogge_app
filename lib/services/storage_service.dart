import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _storage;
  final AndroidOptions _options;

  StorageService(this._storage, this._options);

  Future<void> write({required String? value, required String key}) async {
    try {
      await _storage.write(key: key, value: value, aOptions: _options);
    } catch (error, trace) {
      debugPrint('$error $trace');
    }
  }

  Future<String?> read({required String key}) async {
    try {
      return await _storage.read(key: key, aOptions: _options);
    } catch (error, trace) {
      debugPrint('$error $trace');
      return null;
    }
  }

  Future<void> delete({required String key}) async {
    try {
      await _storage.delete(key: key, aOptions: _options);
    } catch (error, trace) {
      debugPrint('$error $trace');
    }
  }

  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll(aOptions: _options);
    } catch (error, trace) {
      debugPrint('$error $trace');
    }
  }

  // ===== tokens =====

  Future<void> writeRefreshToken(String? token) =>
      write(key: 'refreshToken', value: token);

  Future<void> writeAccessToken(String? token) =>
      write(key: 'accessToken', value: token);

  Future<String?> readRefreshToken() => read(key: 'refreshToken');

  Future<String?> readAccessToken() => read(key: 'accessToken');

  Future<bool> hasTokens() async {
    try {
      final access = await readAccessToken();
      final refresh = await readRefreshToken();
      return access != null && refresh != null;
    } catch (e, trace) {
      debugPrint('$e $trace');
      return false;
    }
  }

  // ===== misc =====

  Future<void> clearStorage() async {
    await writeRefreshToken(null);
    await writeAccessToken(null);
  }
}
