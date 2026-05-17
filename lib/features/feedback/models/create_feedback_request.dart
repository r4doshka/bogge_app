import 'package:json_annotation/json_annotation.dart';

part 'create_feedback_request.g.dart';

@JsonSerializable(includeIfNull: false)
class CreateFeedbackRequest {
  final String title;
  final String message;

  const CreateFeedbackRequest({required this.title, required this.message});

  factory CreateFeedbackRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateFeedbackRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateFeedbackRequestToJson(this);

  CreateFeedbackRequest copyWith({String? title, String? message}) {
    return CreateFeedbackRequest(
      title: title ?? this.title,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'title: $title, message: $message';
  }
}
