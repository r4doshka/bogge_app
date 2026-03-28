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
