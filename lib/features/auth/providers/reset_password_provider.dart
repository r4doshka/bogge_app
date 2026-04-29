import 'package:bogge_app/features/auth/models/reset_password_state.dart';
import 'package:bogge_app/features/auth/notifiers/reset_password_state.dart';
import 'package:hooks_riverpod/legacy.dart';

final resetPasswordStateProvider =
    StateNotifierProvider.autoDispose<
      ResetPasswordFormStateNotifier,
      ResetPasswordState
    >((ref) => ResetPasswordFormStateNotifier(ref));
