import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/user/models/update_user.dart';
import 'package:bogge_app/features/user/providers/user_provider.dart';
import 'package:bogge_app/providers/navigation/routers/authorized/authorized_router.gr.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:bogge_app/ui/widgets/form/group_radio_buttons.dart';
import 'package:bogge_app/ui/widgets/progress_line.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class OnboardingGenderScreen extends HookConsumerWidget {
  const OnboardingGenderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);
    final user = ref.watch(userProvider);
    final sexType = useState<SexType?>(user?.sex);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpace.ph16,
          child: Column(
            children: [
              AppSpace.h68,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ProgressLine(currentIndex: 1)],
              ),
              AppSpace.h32,
              Text(
                'Какого вы пола?'.tr(),
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
              RadioButtonsGroup<SexType>(
                options: SexType.options,
                selectedValue: sexType.value,
                onChange: (val) => sexType.value = val,
              ),
              Spacer(),
              PrimaryButton(
                text: 'Далее'.tr(),
                onPress: sexType.value == null
                    ? null
                    : () async {
                        try {
                          if (sexType.value != user?.sex) {
                            final data = UpdateUser(sex: sexType.value);
                            final newUser = await ref
                                .read(userProvider.notifier)
                                .updateUser(data);

                            if (newUser?.sex == null && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Что-то пошло не так'.tr()),
                                ),
                              );
                              return;
                            }
                          }
                          if (context.mounted) {
                            context.router.push(const OnboardingAgeRoute());
                            return;
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Что-то пошло не так'.tr()),
                              ),
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
