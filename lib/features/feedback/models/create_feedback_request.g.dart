// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_feedback_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateFeedbackRequest _$CreateFeedbackRequestFromJson(
  Map<String, dynamic> json,
) => CreateFeedbackRequest(
  title: json['title'] as String,
  message: json['message'] as String,
);

Map<String, dynamic> _$CreateFeedbackRequestToJson(
  CreateFeedbackRequest instance,
) => <String, dynamic>{'title': instance.title, 'message': instance.message};
