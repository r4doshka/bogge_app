import 'dart:async';

import 'package:bogge_app/services/navigation_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

final networkConnectivityProvider =
    ChangeNotifierProvider<NetworkConnectivityNotifier>((ref) {
      return NetworkConnectivityNotifier(ref);
    });

class NetworkConnectivityNotifier extends ChangeNotifier {
  final Ref ref;

  final Connectivity _connectivity = Connectivity();
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  bool _hasConnection = false;
  bool get hasConnection => _hasConnection;

  Timer? _debounceTimer;

  NetworkConnectivityNotifier(this.ref) {
    _init();
  }

  Future<void> _init() async {
    final results = await _connectivity.checkConnectivity();

    _updateState(results);

    _subscription = _connectivity.onConnectivityChanged.listen(_updateState);
  }

  Future<void> _updateState(List<ConnectivityResult> results) async {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final hasPhysical = results.any(
        (r) => r != ConnectivityResult.none && r != ConnectivityResult.vpn,
      );

      if (_hasConnection != hasPhysical) {
        _hasConnection = hasPhysical;
        notifyListeners();
      }
    });
  }

  Future<void> recheckConnection() async {
    final results = await _connectivity.checkConnectivity();
    await _updateState(results);
  }

  void setConnection(bool state) {
    final navigationService = ref.read(navigationServiceProvider);

    if (navigationService.layoutContext != null &&
        navigationService.layoutContext!.mounted) {
      _hasConnection = state;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }
}
