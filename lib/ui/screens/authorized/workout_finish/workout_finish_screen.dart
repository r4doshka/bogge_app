import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/check_button.dart';
import 'package:bogge_app/ui/widgets/lists/stat_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class WorkoutFinishScreen extends ConsumerWidget {
  const WorkoutFinishScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpace.ph16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [CheckButton(onPress: () => context.router.pop())],
              ),
              AppSpace.h8,
              Text(
                'Статистика'.tr(),
                style: text_s34_w700_ls04.copyWith(color: palette.text),
              ),
              Text(
                'Вторник, 10 февраля',
                style: text_s14_w400_ls01.copyWith(color: palette.primary),
              ),
              AppSpace.h16,
              StatList(),
            ],
          ),
        ),
      ),
    );
  }
}
