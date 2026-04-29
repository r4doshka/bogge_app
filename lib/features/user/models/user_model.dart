import 'package:bogge_app/utils/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String email;
  final bool isEmailVerified;
  final String? name;
  final String? surname;
  final SexType? sex;
  final DateTime? dateOfBirth;
  final double? height;
  final double? weight;

  UserModel({
    required this.isEmailVerified,
    required this.email,
    this.name,
    this.surname,
    this.sex,
    this.dateOfBirth,
    this.height,
    this.weight,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? email,
    String? password,
    String? name,
    String? surname,
    SexType? sex,
    DateTime? dateOfBirth,
    double? height,
    double? weight,
    String? role,
    int? tokenVersion,
    bool? isEmailVerified,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      sex: sex ?? this.sex,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  String? get fullName => '${name ?? ''} ${surname ?? ''}';

  @override
  String toString() {
    return "email: $email, name: $name, surname: $surname, sex: $sex, dateOfBirth: $dateOfBirth, height: $height, weight: $weight, isEmailVerified: $isEmailVerified";
  }
}
