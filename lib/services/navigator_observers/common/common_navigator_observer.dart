import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/services/navigator_observers/common/navigation_store.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final commonNavigatorObserverProvider = Provider<CommonNavigatorObserver>((
  ref,
) {
  return CommonNavigatorObserver(ref);
});

class CommonNavigatorObserver extends AutoRouterObserver {
  final Ref ref;

  CommonNavigatorObserver(this.ref);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logDropdownRoute(route);
    _updateStack(route, previousRoute, ActionType.push);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _updateStack(route, previousRoute, ActionType.pop);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final notifier = ref.read(navigationStoreProvider.notifier);
    final stack = ref.read(navigationStoreProvider);

    notifier.replaceRoute(oldRoute, newRoute);

    debugPrint(
      'Stack after replace: ${stack.map((r) => _routeName(r)).toList()}',
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final notifier = ref.read(navigationStoreProvider.notifier);
    final stack = ref.read(navigationStoreProvider);

    notifier.removeRoute(route);

    debugPrint(
      'Stack after remove: ${stack.map((r) => _routeName(r)).toList()}',
    );
  }

  void _updateStack(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
    ActionType action,
  ) {
    final notifier = ref.read(navigationStoreProvider.notifier);
    final stack = ref.read(navigationStoreProvider);

    switch (action) {
      case ActionType.push:
        notifier.addRoute(route);
        debugPrint(
          'Stack after push: ${stack.map((r) => _routeName(r)).toList()}',
        );
        break;
      case ActionType.pop:
        notifier.removeRoute(route);
        debugPrint(
          'Stack after pop: ${stack.map((r) => _routeName(r)).toList()}',
        );
        break;
    }
  }

  void clearStack() {
    final notifier = ref.read(navigationStoreProvider.notifier);
    notifier.clear();
  }

  String _routeName(Route<dynamic> route) {
    if (route.runtimeType.toString().contains('DropdownRoute')) {
      return '/dropdown';
    }
    return route.settings.name ?? 'Unnamed Route';
  }

  void _logDropdownRoute(Route<dynamic> route) {
    final typeName = route.runtimeType.toString();
    if (typeName.contains('DropdownRoute')) {
      debugPrint('[ROUTE] Detected internal DropdownRoute');
    }
  }
}

enum ActionType { push, pop }
