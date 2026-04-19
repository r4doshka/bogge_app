import 'package:bogge_app/features/auth/models/sign_up_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

class SignUpFormStateNotifier extends StateNotifier<SignUpState> {
  final Ref ref;

  SignUpFormStateNotifier(this.ref) : super(SignUpState.unknown());
}
