import 'package:bogge_app/features/auth/models/change_email_state.dart';
import 'package:bogge_app/features/auth/notifiers/change_email_state.dart';
import 'package:hooks_riverpod/legacy.dart';

final changeEmailStateProvider =
    StateNotifierProvider.autoDispose<
      ChangeEmailFormStateNotifier,
      ChangeEmailState
    >((ref) => ChangeEmailFormStateNotifier(ref));
