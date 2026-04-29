import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/providers/navigation/routers/authorized/authorized_router.gr.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:bogge_app/ui/widgets/form/date_picker.dart';
import 'package:bogge_app/ui/widgets/progress_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class OnboardingAgeScreen extends ConsumerWidget {
  const OnboardingAgeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpace.ph16,
          child: Column(
            children: [
              AppSpace.h68,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ProgressLine(currentIndex: 2)],
              ),
              AppSpace.h32,
              Text(
                'Каков ваш возраст'.tr(),
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
              DatePicker(
                initialValue: [],
                onValueChanged: (val) {
                  print('======> val');
                },
              ),
              Spacer(),
              PrimaryButton(
                text: 'Далее'.tr(),
                onPress: 1 > 0
                    ? null
                    : () {
                        context.router.replace(const OnboardingHeightRoute());
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
