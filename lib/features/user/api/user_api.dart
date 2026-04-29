import 'package:bogge_app/features/auth/api/backend_error_code_parser.dart';
import 'package:bogge_app/features/auth/api/backend_success_code_parser.dart';
import 'package:bogge_app/features/user/models/update_user.dart';
import 'package:bogge_app/features/user/models/user_model.dart';
import 'package:bogge_app/services/http/core/http_client_base.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userRepository = Provider<UserRepositoryAPI>(
  (ref) => UserRepositoryAPI(ref),
);

abstract class UserRepository {
  Future<UserModel?> getUser();
  Future<UserModel?> updateUser(UpdateUser data);
}

class UserRepositoryAPI implements UserRepository {
  final Ref ref;
  UserRepositoryAPI(this.ref);

  static const String path = "/api/users";

  @override
  Future<UserModel?> getUser() async {
    final response = await ref
        .read(httpProvider.notifier)
        .get(
          query: '$path/me',
          type: AuthType.bearer,
          errorMapper: BackendErrorCodeX.fromCode,
          successMapper: AuthSuccessCodeX.fromCode,
        );

    if (!response.success || response.data == null) {
      return null;
    }

    try {
      final json = response.data as Map<String, dynamic>;

      return UserModel.fromJson(json);
    } catch (e, trace) {
      debugPrint('getUser error: $e, $trace');
      return null;
    }
  }

  @override
  Future<UserModel?> updateUser(data) async {
    final response = await ref
        .read(httpProvider.notifier)
        .patch(
          query: '$path/me',
          type: AuthType.bearer,
          data: data.toJson(),
          errorMapper: BackendErrorCodeX.fromCode,
          successMapper: AuthSuccessCodeX.fromCode,
        );

    if (!response.success || response.data == null) {
      return null;
    }

    try {
      final json = response.data as Map<String, dynamic>;

      return UserModel.fromJson(json);
    } catch (e, trace) {
      debugPrint('getUser error: $e, $trace');
      return null;
    }
  }
}
