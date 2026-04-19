import 'package:bogge_app/features/auth/api/backend_error_code_parser.dart';
import 'package:bogge_app/features/auth/api/backend_success_code_parser.dart';
import 'package:bogge_app/features/auth/models/sign_up_state.dart';
import 'package:bogge_app/features/auth/providers/sign_up_provider.dart';
import 'package:bogge_app/models/api_response.dart';
import 'package:bogge_app/services/http/core/http_client_base.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authRepository = Provider<AuthRepositoryAPI>(
  (ref) => AuthRepositoryAPI(ref),
);

abstract class AuthRepository {
  Future<void> signIn();
  Future<ApiResponse<void, AuthBackendErrorCode, AuthSuccessCode>> signUp();
  Future<void> getConfirmCode();
  Future<void> confirmEmail();
  Future<void> logout();
}

class AuthRepositoryAPI implements AuthRepository {
  final Ref ref;
  AuthRepositoryAPI(this.ref);

  static const String path = "/api/auth";

  @override
  Future<void> signIn() async {}

  @override
  Future<ApiResponse<void, AuthBackendErrorCode, AuthSuccessCode>>
  signUp() async {
    final state = ref.read(signUpStateProvider);

    final String email = state.signUpForm
        .control(SignUpState.emailFieldName)
        .value;

    final String password = state.signUpForm
        .control(SignUpState.passwordFieldName)
        .value;

    final response = await ref
        .read(httpProvider.notifier)
        .post(
          query: '$path/register',
          type: AuthType.basic,
          data: {"email": email, "password": password},
          errorMapper: BackendErrorCodeX.fromCode,
          successMapper: AuthSuccessCodeX.fromCode,
        );

    return response;
  }

  @override
  Future<void> getConfirmCode() async {}
  @override
  Future<void> confirmEmail() async {}
  @override
  Future<void> logout() async {}
}
