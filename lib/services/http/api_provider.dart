import 'package:bogge_app/models/bearer_token.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:flutter/material.dart';

import 'core/i_http_client.dart';

class ApiProvider {
  BaseHttpClient _httpClient;

  ApiProvider(this._httpClient);

  void updateHttpClient(BaseHttpClient newHttpClient) {
    _httpClient = newHttpClient;
  }

  BaseHttpClient get httpClient => _httpClient;
}

extension AuthService on ApiProvider {
  static const String patch = "/security";

  Future<dynamic> signUp({
    required String code,
    required String username,
  }) async {
    try {
      final response = await _httpClient.post(
        query: '/security/api/v1/registration/emailConfirmation/mobile',
        type: AuthType.basic,
        data: {'code': int.parse(code), "username": username},
      );

      return response;
    } catch (e) {
      debugPrint('signUp error ====> $e');
      rethrow;
    }
  }

  checkToken() async {
    try {
      await _httpClient.post(
        query: '/security/api/v1/registration/emailConfirmation/mobile',
        type: AuthType.basic,
      );
    } catch (e, stack) {
      debugPrint('checkToken error ===> $e, $stack');
      return TokenStatus.inactive;
    }
  }

  Future<BearerToken> refreshToken(String refreshToken) async {
    _httpClient.accessToken = refreshToken;
    final responseData = await _httpClient.post(
      query: '/v1/auth/refresh-tokens',
      type: AuthType.basic,
    );
    BearerToken bearerToken = BearerToken.fromJson(responseData);
    _httpClient.accessToken = bearerToken.access;
    return bearerToken;
  }
}
