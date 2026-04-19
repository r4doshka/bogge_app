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
