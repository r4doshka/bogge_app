import 'package:bogge_app/utils/enums.dart';
import 'package:dio/dio.dart';

abstract class BaseHttpClient {
  String? accessToken;

  Future get({
    required String query,
    AuthType type = AuthType.none,
    Map<String, dynamic>? queryParameters,
    String? baseUrl,
  });

  Future post({
    required String query,
    Object? data,
    AuthType type = AuthType.none,
    String? baseUrl,
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  });

  Future patch({
    required String query,
    Map<String, dynamic>? data,
    AuthType type = AuthType.none,
    bool useBaseUrl = true,
  });

  Future put({
    required String query,
    Map<String, dynamic>? data,
    AuthType type = AuthType.none,
  });

  Future delete({
    required String query,
    Map<String, dynamic>? data,
    AuthType type = AuthType.none,
    Map<String, dynamic>? queryParameters,
  });

  // Future<bool> refreshToken();
  // Future<TokenStatus> checkToken();

  Future<void> setHeaders();
  Map<String, dynamic> getHeaders();
}
