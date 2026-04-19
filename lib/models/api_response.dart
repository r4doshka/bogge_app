import 'package:bogge_app/utils/enums.dart';

class ApiResponse<T, E, S> {
  final bool success;
  final String code;
  final String? message;
  final T? data;

  final E? errorCode;
  final S? successCode;

  ApiResponse({
    required this.success,
    required this.code,
    this.message,
    this.data,
    this.errorCode,
    this.successCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    E Function(String? code)? errorMapper,
    S Function(String? code)? successMapper,
  }) {
    final code = json['code'] as String?;

    assert(
      errorMapper != null || E == dynamic || E == DefaultBackendErrorCode,
      'errorMapper is required for custom error type',
    );
    assert(
      successMapper != null || S == dynamic || S == DefaultSuccessCode,
      'successMapper is required for custom success type',
    );

    return ApiResponse(
      success: json['success'] as bool,
      code: json['code'] as String,
      message: json['message'] as String?,
      data: json['data'],
      errorCode: errorMapper != null
          ? errorMapper(code)
          : DefaultBackendErrorCode.error as E,

      successCode: successMapper != null
          ? successMapper(code)
          : DefaultSuccessCode.success as S,
    );
  }

  @override
  String toString() {
    return 'success: $success, code: $code, message: $message, data: $data';
  }
}
