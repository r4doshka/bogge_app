import 'package:bogge_app/features/auth/api/backend_error_code_parser.dart';

class ApiException implements Exception {
  final AuthBackendErrorCode code;
  final String? message;

  ApiException(this.code, [this.message]);
}
