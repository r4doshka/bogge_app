import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final navigationStoreProvider =
    StateNotifierProvider<NavigationStore, List<Route<dynamic>>>(
      (ref) => NavigationStore(),
    );

class NavigationStore extends StateNotifier<List<Route<dynamic>>> {
  NavigationStore() : super(<Route<dynamic>>[]);

  void addRoute(Route<dynamic> route) {
    state = [...state, route];
  }

  void removeRoute(Route<dynamic> route) {
    state = state.where((r) => r != route).toList();
  }

  void replaceRoute(Route<dynamic>? oldRoute, Route<dynamic>? newRoute) {
    final list = [...state];
    if (oldRoute != null) list.remove(oldRoute);
    if (newRoute != null) list.add(newRoute);
    state = list;
  }

  void clear() {
    state = [];
  }

  bool containsRouteName(String name) {
    return state.any((r) => r.settings.name == name);
  }

  bool runIfRouteNotInStack(String routeName, VoidCallback action) {
    final exists = containsRouteName(routeName);

    if (exists) {
      debugPrint('[NAV] Skip $routeName — already in stack');
      return false;
    }

    action();
    return true;
  }
}
