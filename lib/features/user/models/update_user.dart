import 'package:bogge_app/features/user/models/user_model.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_user.g.dart';

@JsonSerializable(includeIfNull: false)
class UpdateUser {
  final String? name;
  final String? surname;
  @SexTypeConverter()
  final SexType? sex;
  final String? dateOfBirth;
  final double? height;
  final double? weight;

  UpdateUser({
    this.name,
    this.surname,
    this.sex,
    this.dateOfBirth,
    this.height,
    this.weight,
  });

  factory UpdateUser.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserToJson(this);

  static SexType? fromCode(int? code) {
    if (code == null) return null;

    for (final item in SexType.values) {
      if (item.code == code) return item;
    }

    return null;
  }

  UpdateUser copyWith({
    Nullable<String>? name,
    Nullable<String>? surname,
    Nullable<String>? email,
    Nullable<SexType>? sex,
    Nullable<String>? dateOfBirth,
    Nullable<double>? height,
    Nullable<double>? weight,
  }) {
    return UpdateUser(
      name: name != null ? name.value : this.name,
      surname: surname != null ? surname.value : this.surname,
      sex: sex != null ? sex.value : this.sex,
      dateOfBirth: dateOfBirth != null ? dateOfBirth.value : this.dateOfBirth,
      height: height != null ? height.value : this.height,
      weight: weight != null ? weight.value : this.weight,
    );
  }
}

class Nullable<T> {
  final T? value;
  const Nullable(this.value);
}
