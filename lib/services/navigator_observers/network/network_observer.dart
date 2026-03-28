import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/services/navigation_service.dart';
import 'package:bogge_app/services/network_connectivity_notifier.dart';
import 'package:bogge_app/ui/widgets/modals/internet_warning_modal_bottom.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final networkDialogObserverProvider = Provider<NetworkDialogObserver>((ref) {
  return NetworkDialogObserver(ref);
});

class NetworkDialogObserver extends NavigatorObserver {
  final Ref ref;

  bool _isDialogShown = false;

  NetworkDialogObserver(this.ref) {
    ref.read(networkConnectivityProvider).addListener(_onConnectivityChanged);
  }

  NetworkConnectivityNotifier get _connectivity =>
      ref.read(networkConnectivityProvider);

  NavigationService get _navigationService =>
      ref.read(navigationServiceProvider);

  void _onConnectivityChanged() {
    if (_navigationService.layoutContext == null) return;

    if (!_connectivity.hasConnection) {
      _showNoConnectionDialog(_navigationService.layoutContext!);
    } else {
      _hideDialog(_navigationService.layoutContext!);
    }
  }

  void _showNoConnectionDialog(BuildContext context) async {
    if (_isDialogShown) return;

    _isDialogShown = true;
    await showInternetWarningModalBottom(context: context);
  }

  void _hideDialog(BuildContext context) {
    if (!_isDialogShown) return;

    context.router.pop();
    _isDialogShown = false;
  }

  void dispose() {
    ref
        .read(networkConnectivityProvider)
        .removeListener(_onConnectivityChanged);
  }
}
