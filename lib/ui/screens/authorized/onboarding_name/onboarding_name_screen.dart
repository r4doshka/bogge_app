import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/user/providers/user_provider.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/headers/common_header.dart';
import 'package:bogge_app/ui/widgets/progress_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class OnboardingNameScreen extends ConsumerWidget {
  const OnboardingNameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);
    final state = ref.watch(userProvider);
    print('user ======> $state');

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpace.ph16,
          child: Column(
            children: [
              CommonHeader(onPop: () => context.router.pop()),
              AppSpace.h24,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ProgressLine(currentIndex: 5)],
              ),
              AppSpace.h32,
              Text(
                'Как вас зовут'.tr(),
                style: text_s25_w700_ls04.copyWith(color: palette.text),
              ),
              AppSpace.h16,
              Text(
                'Это поможет нам рассчитать вашу базальную скорость метаболизма и адаптировать ваш план тренировок'
                    .tr(),
                style: text_s14_w400_ls01.copyWith(color: palette.text60),
                textAlign: TextAlign.center,
              ),
              AppSpace.h24,
            ],
          ),
        ),
      ),
    );
  }
}
