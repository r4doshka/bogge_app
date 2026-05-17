import 'package:bogge_app/features/feedback/models/feedback_state.dart';
import 'package:bogge_app/features/feedback/notifiers/feedback_state.dart';
import 'package:hooks_riverpod/legacy.dart';

final feedbackStateProvider =
    StateNotifierProvider.autoDispose<FeedbackFormStateNotifier, FeedbackState>(
      (ref) => FeedbackFormStateNotifier(ref),
    );
