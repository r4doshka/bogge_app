import 'package:bogge_app/features/auth/models/sign_in_state.dart';
import 'package:bogge_app/features/auth/notifiers/sign_in_state.dart';
import 'package:hooks_riverpod/legacy.dart';

final signInStateProvider =
    StateNotifierProvider.autoDispose<SignInFormStateNotifier, SignInState>(
      (ref) => SignInFormStateNotifier(ref),
    );
