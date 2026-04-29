// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  isEmailVerified: json['isEmailVerified'] as bool,
  email: json['email'] as String,
  name: json['name'] as String?,
  surname: json['surname'] as String?,
  sex: $enumDecodeNullable(_$SexTypeEnumMap, json['sex']),
  dateOfBirth: json['dateOfBirth'] == null
      ? null
      : DateTime.parse(json['dateOfBirth'] as String),
  height: (json['height'] as num?)?.toDouble(),
  weight: (json['weight'] as num?)?.toDouble(),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'email': instance.email,
  'isEmailVerified': instance.isEmailVerified,
  'name': instance.name,
  'surname': instance.surname,
  'sex': _$SexTypeEnumMap[instance.sex],
  'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
  'height': instance.height,
  'weight': instance.weight,
};

const _$SexTypeEnumMap = {SexType.male: 'male', SexType.female: 'female'};
