import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/services/navigation_service.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:bogge_app/ui/widgets/headers/common_header.dart';
import 'package:bogge_app/ui/widgets/progress_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:bogge_app/providers/navigation/routers/authorized/authorized_router.gr.dart';

@RoutePage()
class OnboardingAppleHealthScreen extends ConsumerWidget {
  const OnboardingAppleHealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: AppSpace.ph16,
              child: CommonHeader(onPop: () => context.router.pop()),
            ),
            AppSpace.h24,
            Padding(
              padding: AppSpace.ph16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ProgressLine(currentIndex: 6)],
              ),
            ),
            AppSpace.h32,
            Padding(
              padding: AppSpace.ph16,
              child: Text(
                'Apple Health App'.tr(),
                style: text_s25_w700_ls04.copyWith(color: palette.text),
              ),
            ),
            AppSpace.h16,
            Padding(
              padding: AppSpace.ph52,
              child: Text(
                'Синхронизируйте свои тренировки с приложением Apple Health, где они будут отображаться как часть вашей ежедневной активности'
                    .tr(),
                style: text_s14_w400_ls01.copyWith(color: palette.text60),
                textAlign: TextAlign.center,
              ),
            ),
            AppSpace.h60,

            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/apple-health-app-image.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
            AppSpace.h48,
            Padding(
              padding: AppSpace.ph16,
              child: PrimaryButton(
                text: 'Начать'.tr(),
                onPress: () => ref.read(navigationServiceProvider).replaceAll([
                  const HomeRoute(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
