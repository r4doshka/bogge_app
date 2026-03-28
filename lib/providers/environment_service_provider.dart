import 'package:bogge_app/env/env.dart';
import 'package:bogge_app/providers/shared_preferences_provider.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

const String _buildFlavor = String.fromEnvironment(
  'FLAVOR',
  defaultValue: 'prod',
);

class EnvironmentState {
  final String flavor;
  final AppEnvironment current;

  const EnvironmentState({required this.flavor, required this.current});

  bool get isProdFlavor => flavor == 'prod';
  bool get isDevFlavor => flavor == 'dev';

  String get baseUrl => switch (current) {
    AppEnvironment.dev => DevEnv.baseUrl,
    AppEnvironment.prod => ProdEnv.baseUrl,
  };
}

class EnvironmentNotifier extends StateNotifier<EnvironmentState> {
  final Ref ref;

  EnvironmentNotifier(this.ref)
    : super(
        EnvironmentState(flavor: _buildFlavor, current: AppEnvironment.dev),
      ) {
    _init();
  }

  void _init() {
    final preferences = ref.read(sharedPreferencesServiceProvider);
    final saved = preferences.getEnvBaseUrls();

    if (state.isProdFlavor) {
      state = EnvironmentState(
        flavor: state.flavor,
        current: AppEnvironment.prod,
      );
    } else {
      final current = saved != null
          ? AppEnvironmentName.fromName(saved)
          : AppEnvironment.dev;
      state = EnvironmentState(flavor: state.flavor, current: current);
    }

    debugPrint('[ENV] Initialized → ${state.flavor} | ${state.current.name}');
  }

  Future<void> switchEnvironment(AppEnvironment env) async {
    if (state.isProdFlavor) {
      debugPrint('[ENV] Switching disabled in PROD flavor');
      return;
    }
    if (state.current == env) return;

    final preferences = ref.read(sharedPreferencesServiceProvider);
    await preferences.setEnvBaseUrls(env.name);

    state = EnvironmentState(flavor: state.flavor, current: env);
    debugPrint('[ENV] Switched → ${env.name}');
  }
}

final environmentProvider =
    StateNotifierProvider<EnvironmentNotifier, EnvironmentState>(
      (ref) => EnvironmentNotifier(ref),
    );
