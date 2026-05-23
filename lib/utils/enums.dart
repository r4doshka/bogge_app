import 'package:bogge_app/models/radio_button_model.dart';
import 'package:flutter/material.dart';

enum AppEnvironment {
  dev(name: 'Development'),
  prod(name: 'Production');

  final String name;

  const AppEnvironment({required this.name});
}

extension AppEnvironmentName on AppEnvironment {
  static AppEnvironment fromName(String? name) {
    return switch (name) {
      'Development' => AppEnvironment.dev,
      'Production' => AppEnvironment.prod,
      _ => AppEnvironment.dev,
    };
  }
}

enum AuthType { none, basic, bearer, failBearer }

enum FlowType { authorized, unauthorized, guest, init }

enum TokenStatus { active, inactive, offline }

final supportedLocales = [
  Locale(LocaleLanguage.ru.languageCode, LocaleLanguage.ru.countryCode),
];

enum LocaleLanguage {
  ru(countryCode: 'RU', languageCode: 'ru');

  final String languageCode;
  final String countryCode;

  const LocaleLanguage({required this.languageCode, required this.countryCode});
}

enum DefaultBackendErrorCode { error, unknownError }

enum DefaultSuccessCode { success }

enum RequestFailureType {
  network,
  timeout,
  server,
  unauthorized,
  cancelled,
  unknown,
}

enum SexType {
  male(1, 'Мужской'),
  female(2, 'Женский');

  final int code;
  final String label;

  static SexType? fromCode(int? code) {
    if (code == null) return null;

    return SexType.values.where((el) => el.code == code).firstOrNull;
  }

  static List<RadioButtonModel<SexType>> get options =>
      values.map((el) => RadioButtonModel(label: el.label, value: el)).toList();

  const SexType(this.code, this.label);
}

enum ScanStatus { inProgress, error, success }

enum WorkoutStatType {
  steps(title: 'Шаги', unit: '', iconPath: 'assets/icons/step-icon.svg'),
  duration(title: 'Время', unit: 'ч', iconPath: 'assets/icons/timer-icon.svg'),
  calories(
    title: 'Калории',
    unit: 'ккал',
    iconPath: 'assets/icons/fire-icon.svg',
  ),
  distance(
    title: 'Дистанция',
    unit: 'км',
    iconPath: 'assets/icons/location-icon.svg',
  );

  final String title;
  final String unit;
  final String iconPath;

  const WorkoutStatType({
    required this.title,
    required this.unit,
    required this.iconPath,
  });
}
