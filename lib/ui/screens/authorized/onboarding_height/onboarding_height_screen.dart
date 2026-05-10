import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/user/models/update_user.dart';
import 'package:bogge_app/features/user/providers/user_provider.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:bogge_app/ui/widgets/headers/common_header.dart';
import 'package:bogge_app/ui/widgets/height_ruler_picker.dart';
import 'package:bogge_app/ui/widgets/progress_line.dart';
import 'package:bogge_app/utils/is_same_double.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:bogge_app/providers/navigation/routers/authorized/authorized_router.gr.dart';

@RoutePage()
class OnboardingHeightScreen extends HookConsumerWidget {
  const OnboardingHeightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);
    final state = ref.watch(userProvider);
    final currentHeight = useState<double>(state?.height ?? 173.2);

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
                children: [ProgressLine(currentIndex: 3)],
              ),
              AppSpace.h32,
              Text(
                'Какой у вас рост'.tr(),
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
              Expanded(
                child: HeightRulerPicker(
                  initialValue: currentHeight.value,
                  onChanged: (value) {
                    currentHeight.value = value;
                  },
                ),
              ),
              AppSpace.h24,
              PrimaryButton(
                text: 'Далее'.tr(),
                onPress: () async {
                  try {
                    if (!isSameDouble(state?.height, currentHeight.value)) {
                      final data = UpdateUser(height: currentHeight.value);
                      final newUser = await ref
                          .read(userProvider.notifier)
                          .updateUser(data);

                      if (newUser?.height == null && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Что-то пошло не так'.tr())),
                        );
                        return;
                      }
                    }
                    if (context.mounted) {
                      context.router.push(const OnboardingWeightRoute());
                      return;
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Что-то пошло не так'.tr())),
                      );
                      return;
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
