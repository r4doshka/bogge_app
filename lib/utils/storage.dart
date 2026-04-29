import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static AndroidOptions get _getAndroidOptions => const AndroidOptions();
  static FlutterSecureStorage get _secureStorage =>
      const FlutterSecureStorage();

  static Future<void> write({
    required String? value,
    required String key,
  }) async {
    await _secureStorage
        .write(key: key.toString(), value: value, aOptions: _getAndroidOptions)
        .catchError((error, trace) {});
  }

  static Future<String?> read({required String key}) async {
    return await _secureStorage
        .read(key: key.toString(), aOptions: _getAndroidOptions)
        .catchError((error, trace) {
          return null;
        });
  }

  static Future<void> delete({required String key}) async {
    await _secureStorage
        .delete(key: key.toString(), aOptions: _getAndroidOptions)
        .catchError((error, trace) {});
  }

  static Future<void> deleteAll() async {
    await _secureStorage
        .deleteAll(aOptions: _getAndroidOptions)
        .catchError((error, trace) {});
  }

  static Future<void> writeRefreshToken(String? token) async {
    await write(key: "refreshToken", value: token);
  }

  static Future<void> writeAccessToken(String? token) async {
    await write(key: "accessToken", value: token);
  }

  static Future<bool> hasTokens() async {
    try {
      return await readAccessToken() != null &&
          await readRefreshToken() != null;
    } catch (e, trace) {
      debugPrint("$e $trace");
      return false;
    }
  }

  static Future<String?> readRefreshToken() async {
    return await read(key: "refreshToken");
  }

  static Future<String?> readAccessToken() async {
    return await read(key: "accessToken");
  }

  static Future<void> clearStorage() async {
    await writeRefreshToken(null);
    await writeAccessToken(null);
  }
}
