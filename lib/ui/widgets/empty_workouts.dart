import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EmptyWorkouts extends ConsumerWidget {
  const EmptyWorkouts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    return Column(
      children: [
        SvgPicture.asset('assets/icons/foot-icon.svg'),
        AppSpace.h32,
        Text(
          'Пока здесь пусто'.tr(),
          style: text_s25_w700_ls04.copyWith(color: palette.text60),
          textAlign: TextAlign.center,
        ),
        AppSpace.h16,
        Text(
          'Сделайте первый шаг — и мы сохраним все ваши тренировки в этом разделе'
              .tr(),
          style: text_s14_w400_ls01.copyWith(color: palette.text60),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
