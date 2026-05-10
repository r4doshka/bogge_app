import 'package:bogge_app/features/user/api/user_api.dart';
import 'package:bogge_app/features/user/models/update_user.dart';
import 'package:bogge_app/features/user/models/user_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:reactive_forms/reactive_forms.dart';

class UserNotifier extends StateNotifier<UserModel?> {
  final Ref ref;

  UserNotifier(this.ref) : super(null);

  static final dateOfBirthFieldName = 'dateOfBirth';

  final FormGroup dateOfBirthForm = FormGroup({
    dateOfBirthFieldName: FormControl<String>(
      validators: [Validators.required],
    ),
  });

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

  bool isDateOfBirthChanged(DateTime? selectedDate) {
    if (selectedDate == null) return false;

    final oldDate = state?.dateOfBirth;
    if (oldDate == null) return true;

    return DateFormat('yyyy-MM-dd').format(selectedDate) !=
        DateFormat('yyyy-MM-dd').format(oldDate);
  }
}
