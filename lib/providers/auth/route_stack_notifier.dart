import 'package:bogge_app/models/router/router_model.dart';
import 'package:hooks_riverpod/legacy.dart';

final routeStackProvider = StateProvider<RouteStackType>(
  (ref) => RouteStackType.init,
);

final navigationStateProvider = StateProvider<bool>((ref) => false);
