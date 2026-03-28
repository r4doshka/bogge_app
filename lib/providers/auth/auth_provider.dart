import 'package:bogge_app/models/router/router_model.dart';
import 'package:bogge_app/providers/auth/route_stack_notifier.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:bogge_app/utils/storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

class AuthState {
  final FlowType currentFlow;
  final bool isAuth;
  final String? accessToken;
  final String? refreshToken;

  const AuthState({
    required this.currentFlow,
    required this.isAuth,
    required this.accessToken,
    required this.refreshToken,
  });

  AuthState copyWith({
    FlowType? currentFlow,
    bool? isAuth,
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthState(
      currentFlow: currentFlow ?? this.currentFlow,
      isAuth: isAuth ?? this.isAuth,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  AuthNotifier(this.ref)
    : super(
        const AuthState(
          currentFlow: FlowType.init,
          isAuth: false,
          accessToken: null,
          refreshToken: null,
        ),
      );

  // ===== init =====
  Future<void> init() async {
    final accessToken = await Storage.readAccessToken();
    final refreshToken = await Storage.readRefreshToken();

    state = state.copyWith(
      accessToken: accessToken,
      refreshToken: refreshToken,
      isAuth: accessToken != null,
    );
  }

  // ===== setters =====
  void setCurrentFlow(FlowType val) {
    if (state.currentFlow != val) {
      state = state.copyWith(currentFlow: val);
    }
  }

  void setIsAuth(bool val) {
    state = state.copyWith(isAuth: val);
  }

  // ===== loadLoginState =====
  Future<void> loadLoginState() async {
    final accessToken = await Storage.readAccessToken();
    final refreshToken = await Storage.readRefreshToken();
    final isAuth = accessToken != null;

    state = state.copyWith(
      isAuth: isAuth,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    if (isAuth) {
      ref
          .read(routeStackProvider.notifier)
          .update((s) => RouteStackType.authorized);
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref)..init(),
);
