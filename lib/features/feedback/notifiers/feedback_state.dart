import 'package:bogge_app/features/feedback/models/feedback_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

class FeedbackFormStateNotifier extends StateNotifier<FeedbackState> {
  final Ref ref;

  FeedbackFormStateNotifier(this.ref) : super(FeedbackState.unknown());
}
