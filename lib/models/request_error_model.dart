import 'package:bogge_app/utils/enums.dart';

class RequestErrorModel implements Exception {
  final String? errorMessage;
  final int? responseStatus;
  final String? responseError;
  final String? responseMessage;
  final String? responsePath;
  final RequestFailureType failureType;

  const RequestErrorModel({
    required this.errorMessage,
    required this.responseStatus,
    required this.responseError,
    required this.responseMessage,
    required this.responsePath,
    required this.failureType,
  });

  @override
  String toString() {
    return 'errorMessage: $errorMessage, '
        'responseStatus: $responseStatus, '
        'responseError: $responseError, '
        'responseMessage: $responseMessage, '
        'responsePath: $responsePath, '
        'failureType: $failureType';
  }
}
