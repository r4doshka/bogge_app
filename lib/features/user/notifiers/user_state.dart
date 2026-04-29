import 'package:bogge_app/features/user/api/user_api.dart';
import 'package:bogge_app/features/user/models/update_user.dart';
import 'package:bogge_app/features/user/models/user_model.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

class UserNotifier extends StateNotifier<UserModel?> {
  final Ref ref;

  UserNotifier(this.ref) : super(null);

  Future<UserModel?> getUser() async {
    try {
      final userApi = ref.read(userRepository);
      final user = await userApi.getUser();

      state = user;

      return user;
    } catch (e) {
      debugPrint('loadMe $e');
      return null;
    }
  }

  Future<UserModel?> updateUser(UpdateUser data) async {
    try {
      final userApi = ref.read(userRepository);
      final user = await userApi.updateUser(data);

      state = user;

      return user;
    } catch (e) {
      debugPrint('updateUser $e');
      return null;
    }
  }

  void setUser(UserModel user) {
    state = user;
  }

  void clear() {
    state = null;
  }
}
