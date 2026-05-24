import 'package:easy_localization/easy_localization.dart';

String formatDistanceMeters(int meters, [String locale = 'ru']) {
  if (meters < 1000) {
    return '$meters м';
  }

  final km = meters / 1000;

  return '${NumberFormat(km % 1 == 0 ? '0' : '0.#', locale).format(km)} км';
}
