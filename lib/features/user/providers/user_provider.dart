import 'package:bogge_app/features/user/models/user_model.dart';
import 'package:bogge_app/features/user/notifiers/user_state.dart';
import 'package:hooks_riverpod/legacy.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserModel?>(
  (ref) => UserNotifier(ref),
);
