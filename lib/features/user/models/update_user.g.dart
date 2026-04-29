// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUser _$UpdateUserFromJson(Map<String, dynamic> json) => UpdateUser(
  name: json['name'] as String?,
  surname: json['surname'] as String?,
  sex: $enumDecodeNullable(_$SexTypeEnumMap, json['sex']),
  dateOfBirth: json['dateOfBirth'] as String?,
  height: (json['height'] as num?)?.toDouble(),
  weight: (json['weight'] as num?)?.toDouble(),
);

Map<String, dynamic> _$UpdateUserToJson(UpdateUser instance) =>
    <String, dynamic>{
      'name': ?instance.name,
      'surname': ?instance.surname,
      'sex': ?_$SexTypeEnumMap[instance.sex],
      'dateOfBirth': ?instance.dateOfBirth,
      'height': ?instance.height,
      'weight': ?instance.weight,
    };

const _$SexTypeEnumMap = {SexType.male: 'male', SexType.female: 'female'};
