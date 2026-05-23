import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/dot_symbol.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TextWithDotItem extends ConsumerWidget {
  final String text;
  const TextWithDotItem({super.key, required this.text});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DotSymbol(),
        AppSpace.w4,
        Expanded(
          child: Text(
            text,
            style: text_s14_w400_lsm043.copyWith(color: palette.text),
          ),
        ),
      ],
    );
  }
}
