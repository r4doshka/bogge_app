import 'package:bogge_app/ui/ui_tokens/palette.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final paletteProvider = Provider<AppPalette>((ref) {
  return const AppPalette.dark();
});
