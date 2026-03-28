class RequestErrorModel implements Exception {
  final String? errorMessage;
  final int? responseStatus;
  final String? responseError;
  final String? responsePath;

  const RequestErrorModel({
    required this.errorMessage,
    required this.responseStatus,
    required this.responseError,
    required this.responsePath,
  });

  @override
  String toString() {
    return 'errorMessage: $errorMessage,  responseStatus: $responseStatus,  responseError: $responseError, responsePath: $responsePath';
  }
}
