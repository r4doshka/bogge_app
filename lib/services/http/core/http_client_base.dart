import 'dart:async';
import 'dart:io';

import 'package:bogge_app/models/api_response.dart';
import 'package:bogge_app/models/request_error_model.dart';
import 'package:bogge_app/providers/auth/auth_provider.dart';
import 'package:bogge_app/providers/environment_service_provider.dart';
import 'package:bogge_app/providers/storage_provider.dart';
import 'package:bogge_app/services/navigation_service.dart';
import 'package:bogge_app/services/network_connectivity_notifier.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:bogge_app/utils/storage.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

final httpProvider = StateNotifierProvider<DioStateNotifier, Dio>((ref) {
  final env = ref.watch(environmentProvider);
  return DioStateNotifier(ref, env.baseUrl);
});

class DioStateNotifier extends StateNotifier<Dio> {
  final Ref ref;
  final String baseUrl;

  String? accessToken;

  final String basicToken = "Basic ZXhhbXBsZUNsaWVudDpleGFtcGxlU2VjcmV0";

  DioStateNotifier(this.ref, this.baseUrl)
    : super(
        Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 60),
            receiveTimeout: const Duration(seconds: 60),
            headers: {"content-type": "application/json"},
          ),
        ),
      ) {
    _setInterceptors();
  }

  Map<String, dynamic> getHeaders() => state.options.headers;

  Future<void> setHeaders() async {
    final storage = ref.read(storageServiceProvider);
    final token = await storage.readAccessToken();
    accessToken = token;

    if ((accessToken ?? '').isNotEmpty) {
      state.options.headers['Authorization'] = 'Bearer $accessToken';
    }
  }

  Dio _createDioInstance({required String baseUrl}) {
    final headers = {"content-type": "application/json"};

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: headers,
      ),
    );

    _setInterceptors(dio: dio);

    return dio;
  }

  Future<ApiResponse<T, E, S>> get<T, E, S>({
    required String query,
    Map<String, dynamic>? queryParameters,
    AuthType type = AuthType.none,
    String? baseUrl,
    E Function(String?)? errorMapper,
    S Function(String?)? successMapper,
  }) async {
    final client = baseUrl != null
        ? _createDioInstance(baseUrl: baseUrl)
        : state;

    return await _sendRequest(
      client.get(
        query,
        queryParameters: queryParameters,
        options: Options(
          headers: _header(type: type),
          extra: {'authType': type},
        ),
      ),
      errorMapper: errorMapper,
      successMapper: successMapper,
    );
  }

  Future<ApiResponse<T, E, S>> post<T, E, S>({
    required String query,
    Object? data,
    AuthType type = AuthType.none,
    bool useBaseUrl = true,
    String? baseUrl,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    bool withCloudflareInterceptors = false,
    E Function(String?)? errorMapper,
    S Function(String?)? successMapper,
  }) async {
    final client = baseUrl != null
        ? _createDioInstance(baseUrl: baseUrl)
        : state;
    return await _sendRequest(
      client.post(
        query,
        data: data,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        options: Options(
          headers: _header(type: type),
          extra: {'authType': type},
        ),
      ),
      errorMapper: errorMapper,
      successMapper: successMapper,
    );
  }

  Future<ApiResponse<T, E, S>> patch<T, E, S>({
    required String query,
    Map<String, dynamic>? data,
    AuthType type = AuthType.none,
    E Function(String?)? errorMapper,
    S Function(String?)? successMapper,
  }) async {
    return await _sendRequest(
      state.patch(
        query,
        data: data,
        options: Options(
          headers: _header(type: type),
          extra: {'authType': type},
        ),
      ),
      errorMapper: errorMapper,
      successMapper: successMapper,
    );
  }

  Future<ApiResponse<T, E, S>> put<T, E, S>({
    required String query,
    Map<String, dynamic>? data,
    AuthType type = AuthType.none,
    E Function(String?)? errorMapper,
    S Function(String?)? successMapper,
  }) async {
    return await _sendRequest(
      state.put(
        query,
        data: data,
        options: Options(
          headers: _header(type: type),
          extra: {'authType': type},
        ),
      ),
      errorMapper: errorMapper,
      successMapper: successMapper,
    );
  }

  Future<ApiResponse<T, E, S>> delete<T, E, S>({
    required String query,
    Map<String, dynamic>? data,
    AuthType type = AuthType.none,
    bool useBaseUrl = false,
    Map<String, dynamic>? queryParameters,
    E Function(String?)? errorMapper,
    S Function(String?)? successMapper,
  }) async {
    return await _sendRequest(
      state.delete(
        useBaseUrl ? baseUrl + query : query,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: _header(type: type),
          extra: {'authType': type},
        ),
      ),
      errorMapper: errorMapper,
      successMapper: successMapper,
    );
  }

  Map<String, dynamic> _header({required AuthType type}) {
    return {
      "content-type": "application/json",
      if (type == AuthType.bearer) "Authorization": "Bearer $accessToken",
    };
  }

  Future<ApiResponse<T, E, S>> _sendRequest<T, E, S>(
    Future<Response> request, {
    E Function(String?)? errorMapper,
    S Function(String?)? successMapper,
  }) async {
    try {
      final response = await request;

      return ApiResponse<T, E, S>.fromJson(
        response.data,
        errorMapper: errorMapper,
        successMapper: successMapper,
      );
    } on DioException catch (error) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        return ApiResponse<T, E, S>.fromJson(
          data,
          errorMapper: errorMapper,
          successMapper: successMapper,
        );
      }
      throw RequestErrorModel(
        errorMessage: error.message,
        responseStatus: error.response?.statusCode,
        responseError: null,
        responseMessage: null,
        responsePath: error.requestOptions.path,
        failureType: _mapRequestFailure(error),
      );
    }
  }

  RequestFailureType _mapRequestFailure(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return RequestFailureType.timeout;

      case DioExceptionType.connectionError:
        return RequestFailureType.network;

      case DioExceptionType.cancel:
        return RequestFailureType.cancelled;

      case DioExceptionType.badResponse:
        final status = error.response?.statusCode;
        if (status == 401 || status == 403) {
          return RequestFailureType.unauthorized;
        }
        return RequestFailureType.server;

      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return RequestFailureType.unknown;
    }
  }

  void _setInterceptors({Dio? dio}) {
    final currentDio = dio ?? state;
    currentDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // println(
          //   "\n---------- DioRequest ----------"
          //   "\n\turl: ${options.baseUrl}${options.path}"
          //   "\n\tquery: ${options.queryParameters}"
          //   "\n\tmethod: ${options.method}"
          //   "\n\tdata: ${options.data}"
          //   "\n\theaders: ${options.headers}\n}"
          //   "\n--------------------------------\n",
          // );

          final authType =
              (options.extra['authType'] as AuthType?) ?? AuthType.none;

          state.options.headers.forEach((k, v) {
            options.headers.putIfAbsent(k, () => v);
          });

          if (authType == AuthType.none) {
            options.headers.removeWhere(
              (k, _) => k.toLowerCase() == 'authorization',
            );
          }

          return handler.next(options);
        },
        onResponse: (response, handler) async {
          // final options = response.requestOptions;
          // debugPrint(
          //   "\n---------- DioResponse ----------"
          //   "\n\turl: ${options.baseUrl}${options.path}"
          //   "\n\tmethod: ${options.method}"
          //   "\n\\statusCode: ${response.statusCode}"
          //   "\n\tresponse: $response"
          //   "\n--------------------------------\n",
          // );
          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          final options = error.requestOptions;

          debugPrint(
            "\n---------- DioError ----------"
            "\n\turl: ${options.baseUrl}${options.path}"
            "\n\tmethod: ${options.method}"
            "\n\tmessage: ${error.message}"
            "\n\tresponse: ${error.response}"
            "\n--------------------------------\n",
          );

          final hasConnection = ref
              .read(networkConnectivityProvider)
              .hasConnection;

          if (!hasConnection) {
            await Future.delayed(const Duration(seconds: 10));
            return handler.reject(error);
          }

          if (error.response?.statusCode == 401 ||
              error.response?.statusCode == 403) {
            await Storage.deleteAll();
            ref.read(authProvider.notifier).loadLoginState();
            final navigationProvider = ref.read(navigationServiceProvider);
            final layoutContext = navigationProvider.layoutContext;

            if (layoutContext != null && layoutContext.mounted) {
              navigationProvider.goToSignUp(layoutContext);
            }

            return;
          }

          return handler.next(error);
        },
      ),
    );

    (currentDio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };
  }

  // @override
  // Future<bool> refreshToken() async {
  //   try {
  //     String? token = await Storage.readRefreshToken();
  //     if (token == null) return false;
  //     final responseData = await _sendRequest(
  //       _dio.post(
  //         "/security/api/v1/login",
  //         data: {"grantType": "refresh_token", "refreshToken": token},
  //         options: Options(headers: {"Authorization": basicToken}),
  //       ),
  //     );
  //     accessToken = responseData["access_token"];
  //     Storage.writeRefreshToken(responseData["refresh_token"]);
  //     Storage.writeAccessToken(accessToken);
  //     return true;
  //   } catch (e) {
  //     if (e is RequestErrorModel) {
  //       return false;
  //     } else {
  //       throw Exception("Internet Error");
  //     }
  //   }
  // }
}
