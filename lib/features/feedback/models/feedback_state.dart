import 'package:bogge_app/utils/validators/feedback_validator.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:reactive_forms/reactive_forms.dart';

@immutable
class FeedbackState {
  static final titleFieldName = 'title';
  static final messageFieldName = 'message';

  static const int titleMinLength = 2;
  static const int titleMaxLength = 60;

  static const int messageMinLength = 5;
  static const int messageMaxLength = 1000;

  final FormGroup feedbackForm;

  const FeedbackState({required this.feedbackForm});

  FeedbackState.unknown()
    : feedbackForm = FormGroup({
        titleFieldName: FormControl<String>(
          validators: [
            Validators.required,
            Validators.minLength(titleMinLength),
            Validators.maxLength(titleMaxLength),
            Validators.delegate(feedbackTextValidator),
          ],
        ),
        messageFieldName: FormControl<String>(
          validators: [
            Validators.required,
            Validators.minLength(messageMinLength),
            Validators.maxLength(messageMaxLength),
            Validators.delegate(feedbackTextValidator),
          ],
        ),
      });

  factory FeedbackState.fromJson(Map<String, dynamic> json) {
    return FeedbackState(feedbackForm: json["feedbackForm"]);
  }

  String get titleField => titleFieldName;
  String get messageField => messageFieldName;

  Map<String, dynamic> toJson() => {"feedbackForm": feedbackForm};

  @override
  String toString() {
    return '{ controls: ${feedbackForm.controls}, value: ${feedbackForm.value}, errors: ${feedbackForm.errors}}';
  }
}
