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

enum ScanStatus { initial, inProgress, success, empty, error }

enum ConnectionStatus {
  initial,
  connecting,
  connected,
  disconnecting,
  disconnected,
  error,
}

enum TreadmillStatus { idle, running, paused, stopped }

enum WorkoutSpeedControlType {
  increase(iconPath: 'assets/icons/plus-icon.svg'),
  decrease(iconPath: 'assets/icons/minus-icon.svg');

  final String iconPath;
  const WorkoutSpeedControlType({required this.iconPath});
}

enum WorkoutStatsType {
  steps(
    value: 1,
    title: 'Шаги',
    unit: '',
    iconPath: 'assets/icons/step-icon.svg',
  ),
  duration(
    value: 2,
    title: 'Время',
    unit: '',
    iconPath: 'assets/icons/timer-icon.svg',
  ),
  calories(
    value: 3,
    title: 'Калории',
    unit: 'ккал',
    iconPath: 'assets/icons/fire-icon.svg',
  ),
  distance(
    value: 4,
    title: 'Дистанция',
    unit: '',
    iconPath: 'assets/icons/location-icon.svg',
  );

  final String title;
  final String unit;
  final String iconPath;
  final int value;

  const WorkoutStatsType({
    required this.title,
    required this.unit,
    required this.iconPath,
    required this.value,
  });
}

enum WorkoutStatsPeriod {
  day(value: 1, title: 'Сегодня', segmentName: 'День', description: 'Всего'),
  week(
    value: 2,
    title: 'На этой неделе',
    segmentName: 'Неделя',
    description: 'В среднем за день',
  ),
  month(
    value: 3,
    title: 'В этом месяце',
    segmentName: 'Месяц',
    description: 'В среднем за день',
  ),
  year(
    value: 4,
    title: 'В этом году',
    segmentName: 'Год',
    description: 'В среднем за день',
  );

  final int value;
  final String title;
  final String segmentName;
  final String description;

  static List<String> get titleList => [
    day.segmentName,
    week.segmentName,
    month.segmentName,
    year.segmentName,
  ];

  const WorkoutStatsPeriod({
    required this.value,
    required this.title,
    required this.segmentName,
    required this.description,
  });
}
