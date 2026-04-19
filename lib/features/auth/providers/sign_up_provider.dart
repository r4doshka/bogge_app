import 'package:bogge_app/features/auth/models/sign_up_state.dart';
import 'package:bogge_app/features/auth/notifiers/sign_up_state.dart';
import 'package:hooks_riverpod/legacy.dart';

final signUpStateProvider =
    StateNotifierProvider.autoDispose<SignUpFormStateNotifier, SignUpState>(
      (ref) => SignUpFormStateNotifier(ref),
    );
