import 'package:bogge_app/features/auth/api/backend_error_code_parser.dart';
import 'package:bogge_app/features/auth/api/backend_success_code_parser.dart';
import 'package:bogge_app/features/feedback/models/create_feedback_request.dart';
import 'package:bogge_app/features/feedback/providers/feedback_provider.dart';
import 'package:bogge_app/services/http/core/http_client_base.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final feedbackRepository = Provider<FeedbackRepositoryAPI>(
  (ref) => FeedbackRepositoryAPI(ref),
);

abstract class FeedbackRepository {
  Future<bool> createFeedbackRequest();
}

class FeedbackRepositoryAPI implements FeedbackRepository {
  final Ref ref;
  FeedbackRepositoryAPI(this.ref);

  static const String path = "/api/feedback";

  @override
  Future<bool> createFeedbackRequest() async {
    final state = ref.read(feedbackStateProvider);
    final form = state.feedbackForm;

    final title = form.control(state.titleField).value.trim();
    final message = form.control(state.messageField).value.trim();

    final data = CreateFeedbackRequest(title: title, message: message);

    final response = await ref
        .read(httpProvider.notifier)
        .post(
          query: path,
          data: data.toJson(),
          type: AuthType.bearer,
          errorMapper: BackendErrorCodeX.fromCode,
          successMapper: AuthSuccessCodeX.fromCode,
        );

    if (!response.success || response.data == null) {
      final title = form.control(state.titleField);
      final message = form.control(state.messageField);

      title.setErrors({'common': true});
      title.markAsTouched();

      message.setErrors({'common': true});
      message.markAsTouched();
      return false;
    }

    return true;
  }
}
