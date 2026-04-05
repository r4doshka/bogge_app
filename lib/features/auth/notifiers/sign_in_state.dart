import 'package:bogge_app/features/auth/models/sign_in_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

class SignInFormStateNotifier extends StateNotifier<SignInState> {
  final Ref ref;

  SignInFormStateNotifier(this.ref) : super(SignInState.unknown());
}
