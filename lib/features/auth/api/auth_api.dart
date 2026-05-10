import 'package:bogge_app/features/auth/api/backend_error_code_parser.dart';
import 'package:bogge_app/features/auth/api/backend_success_code_parser.dart';
import 'package:bogge_app/features/auth/models/reset_password_state.dart';
import 'package:bogge_app/features/auth/models/sign_up_state.dart';
import 'package:bogge_app/features/auth/models/token_response.dart';
import 'package:bogge_app/features/auth/providers/reset_password_provider.dart';
import 'package:bogge_app/features/auth/providers/sign_in_provider.dart';
import 'package:bogge_app/features/auth/providers/sign_up_provider.dart';
import 'package:bogge_app/models/api_response.dart';
import 'package:bogge_app/providers/auth/auth_provider.dart';
import 'package:bogge_app/providers/storage_provider.dart';
import 'package:bogge_app/services/http/core/http_client_base.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authRepository = Provider<AuthRepositoryAPI>(
  (ref) => AuthRepositoryAPI(ref),
);

abstract class AuthRepository {
  Future<ApiResponse<void, AuthBackendErrorCode, AuthSuccessCode>> signIn();
  Future<ApiResponse<void, AuthBackendErrorCode, AuthSuccessCode>> signUp();
  Future<ApiResponse<void, AuthBackendErrorCode, AuthSuccessCode>>
  getConfirmCode();
  Future<ApiResponse<void, AuthBackendErrorCode, AuthSuccessCode>>
  confirmEmail();
  Future<ApiResponse<void, AuthBackendErrorCode, AuthSuccessCode>>
  forgotPassword();
  Future<ApiResponse<void, AuthBackendErrorCode, AuthSuccessCode>>
  resetPassword();
  Future<void> logout();
  Future<TokenStatus> checkToken();
  Future<bool> refreshToken();
}

class AuthRepositoryAPI implements AuthRepository {
  final Ref ref;
  AuthRepositoryAPI(this.ref);

  static const String path = "/api/auth";

  @override
  Future<ApiResponse<void, AuthBackendErrorCode, AuthSuccessCode>>
  signIn() async {
    final state = ref.read(signInStateProvider);

    final String email = state.signInForm
        .control(SignUpState.emailFieldName)
        .value;

    final String password = state.signInForm
        .control(SignUpState.passwordFieldName)
        .value;

    final response = await ref
        .read(httpProvider.notifier)
        .post(
          query: '$path/login',
          type: AuthType.basic,
          data: {"email": email, "password": password},
          errorMapper: BackendErrorCodeX.fromCode,
          successMapper: AuthSuccessCodeX.fromCode,
        );

    if (!response.success || response.data == null) {
      return response;
    }

    bool tokensSaved = false;

    try {
      final json = response.data as Map<String, dynamic>;

      final token = TokenResponse.fromJson(json);

      final storage = ref.read(storageServiceProvider);

      await storage.writeAccessToken(token.accessToken);
      await storage.writeRefreshToken(token.refreshToken);
      await ref.read(authProvider.notifier).loadLoginState();
      tokensSaved = true;
    } catch (e, trace) {
      debugPrint('Token parse error: $e, $trace');
    }

    if (!tokensSaved) {
      return ApiResponse(
        success: false,
        code: RequestFailureType.server.name.toUpperCase(),
        message: 'Invalid auth response',
      );
    }

    return response;
  }

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
  Future<ApiResponse<void, AuthBackendErrorCode, AuthSuccessCode>>
  confirmEmail() async {
    final state = ref.read(signUpStateProvider);

    final String email = state.signUpForm
        .control(SignUpState.emailFieldName)
        .value;
    final confirmCode = state.confirmCode;

    final response = await ref
        .read(httpProvider.notifier)
        .post(
          query: '$path/verify',
          type: AuthType.basic,
          data: {"email": email, "code": confirmCode},
          errorMapper: BackendErrorCodeX.fromCode,
          successMapper: AuthSuccessCodeX.fromCode,
        );

    if (!response.success || response.data == null) {
      return response;
    }

    bool tokensSaved = false;

    try {
      final json = response.data as Map<String, dynamic>;

      final token = TokenResponse.fromJson(json);

      final storage = ref.read(storageServiceProvider);

      await storage.writeAccessToken(token.accessToken);
      await storage.writeRefreshToken(token.refreshToken);
      await ref.read(authProvider.notifier).loadLoginState();
      tokensSaved = true;
    } catch (e, trace) {
      debugPrint('Token parse error: $e, $trace');
    }

    if (!tokensSaved) {
      return ApiResponse(
        success: false,
        code: RequestFailureType.server.name.toUpperCase(),
        message: 'Invalid auth response',
      );
    }

    return response;
  }

  @override
  Future<ApiResponse<void, AuthBackendErrorCode, AuthSuccessCode>>
  getConfirmCode() async {
    final state = ref.read(signUpStateProvider);

    final String email = state.signUpForm
        .control(SignUpState.emailFieldName)
        .value;

    final response = await ref
        .read(httpProvider.notifier)
        .post(
          query: '$path/resend-confirmation',
          type: AuthType.basic,
          data: {"email": email},
          errorMapper: BackendErrorCodeX.fromCode,
          successMapper: AuthSuccessCodeX.fromCode,
        );

    return response;
  }

  @override
  Future<void> logout() async {}

  @override
  Future<ApiResponse<void, AuthBackendErrorCode, AuthSuccessCode>>
  forgotPassword() async {
    final state = ref.read(resetPasswordStateProvider);

    final String email = state.resetPasswordForm
        .control(ResetPasswordState.emailFieldName)
        .value;

    final response = await ref
        .read(httpProvider.notifier)
        .post(
          query: '$path/forgot-password',
          type: AuthType.basic,
          data: {"email": email},
          errorMapper: BackendErrorCodeX.fromCode,
          successMapper: AuthSuccessCodeX.fromCode,
        );

    return response;
  }

  @override
  Future<ApiResponse<void, AuthBackendErrorCode, AuthSuccessCode>>
  resetPassword() async {
    final state = ref.read(resetPasswordStateProvider);

    final String email = state.resetPasswordForm
        .control(ResetPasswordState.emailFieldName)
        .value;

    final String newPassword = state.createNewPasswordForm
        .control(ResetPasswordState.secondPasswordFieldName)
        .value;

    final code = state.confirmCode;

    final response = await ref
        .read(httpProvider.notifier)
        .post(
          query: '$path/reset-password',
          type: AuthType.basic,
          data: {"email": email, "password": newPassword, "code": code},
          errorMapper: BackendErrorCodeX.fromCode,
          successMapper: AuthSuccessCodeX.fromCode,
        );

    if (!response.success || response.data == null) {
      return response;
    }

    bool tokensSaved = false;

    try {
      final json = response.data as Map<String, dynamic>;

      final token = TokenResponse.fromJson(json);

      final storage = ref.read(storageServiceProvider);

      await storage.writeAccessToken(token.accessToken);
      await storage.writeRefreshToken(token.refreshToken);
      await ref.read(authProvider.notifier).loadLoginState();
      tokensSaved = true;
    } catch (e, trace) {
      debugPrint('Token parse error: $e, $trace');
    }

    if (!tokensSaved) {
      return ApiResponse(
        success: false,
        code: RequestFailureType.server.name.toUpperCase(),
        message: 'Invalid auth response',
      );
    }

    return response;
  }

  @override
  Future<TokenStatus> checkToken() async {
    await ref.read(httpProvider.notifier).setHeaders();

    final response = await ref
        .read(httpProvider.notifier)
        .post(
          query: '$path/check',
          type: AuthType.bearer,
          errorMapper: BackendErrorCodeX.fromCode,
          successMapper: AuthSuccessCodeX.fromCode,
        );

    if (!response.success) {
      return TokenStatus.inactive;
    }

    return response.data["valid"] == true
        ? TokenStatus.active
        : TokenStatus.inactive;
  }

  @override
  Future<bool> refreshToken() async {
    final storage = ref.read(storageServiceProvider);

    final refreshToken = await storage.readRefreshToken();

    final response = await ref
        .read(httpProvider.notifier)
        .post(
          query: '$path/refresh',
          type: AuthType.bearer,
          data: {"refreshToken": refreshToken},
          errorMapper: BackendErrorCodeX.fromCode,
          successMapper: AuthSuccessCodeX.fromCode,
        );

    if (!response.success || response.data == null) {
      return false;
    }

    bool tokensSaved = false;

    try {
      final json = response.data as Map<String, dynamic>;

      final token = TokenResponse.fromJson(json);

      final storage = ref.read(storageServiceProvider);

      await storage.writeAccessToken(token.accessToken);
      await storage.writeRefreshToken(token.refreshToken);
      await ref.read(authProvider.notifier).loadLoginState();
      tokensSaved = true;
    } catch (e, trace) {
      debugPrint('Token parse error: $e, $trace');
    }

    return tokensSaved;
  }
}
