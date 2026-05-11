import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/user/models/update_user.dart';
import 'package:bogge_app/features/user/providers/user_provider.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:bogge_app/ui/widgets/headers/common_header.dart';
import 'package:bogge_app/ui/widgets/progress_line.dart';
import 'package:bogge_app/ui/widgets/weight_ruler_picker.dart';
import 'package:bogge_app/utils/is_same_double.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:bogge_app/providers/navigation/routers/authorized/authorized_router.gr.dart';

@RoutePage()
class OnboardingWeightScreen extends HookConsumerWidget {
  const OnboardingWeightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);
    final state = ref.watch(userProvider);
    final currentWeight = useState<double>(state?.weight ?? 65.0);
    final isSubmitting = useState(false);

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
                children: [ProgressLine(currentIndex: 4)],
              ),
              AppSpace.h32,
              Text(
                'Какой у вас вес'.tr(),
                style: text_s25_w700_ls04.copyWith(color: palette.text),
              ),
              AppSpace.h16,
              Text(
                'Это поможет нам рассчитать вашу базальную скорость метаболизма и адаптировать ваш план тренировок'
                    .tr(),
                style: text_s14_w400_ls01.copyWith(color: palette.text60),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 130.h),
              SizedBox(
                height: 180.h,
                child: WeightRulerPicker(
                  initialValue: currentWeight.value,
                  onChanged: (value) {
                    currentWeight.value = value;
                  },
                ),
              ),
              Spacer(),
              AppSpace.h24,
              PrimaryButton(
                text: 'Далее'.tr(),
                isLoading: isSubmitting.value,
                onPress: isSubmitting.value
                    ? null
                    : () async {
                        isSubmitting.value = true;

                        try {
                          if (!isSameDouble(
                            state?.weight,
                            currentWeight.value,
                          )) {
                            final data = UpdateUser(
                              weight: currentWeight.value,
                            );
                            final newUser = await ref
                                .read(userProvider.notifier)
                                .updateUser(data);

                            if (newUser?.weight == null && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Что-то пошло не так'.tr()),
                                ),
                              );
                              return;
                            }
                          }
                          if (context.mounted) {
                            context.router.push(const OnboardingNameRoute());
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
                        } finally {
                          if (context.mounted) {
                            isSubmitting.value = false;
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
