import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:bogge_app/ui/widgets/containers/dismiss_keyboard_container.dart';
import 'package:bogge_app/ui/widgets/headers/common_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SignUpConfirmationScreen extends ConsumerWidget {
  final String email;
  const SignUpConfirmationScreen({required this.email, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);
    return Scaffold(
      body: DismissKeyboardContainer(
        child: SafeArea(
          child: Padding(
            padding: AppSpace.ph16,
            child: Column(
              children: [
                CommonHeader(),
                AppSpace.h16,
                Text(
                  'Проверочный код'.tr(),
                  style: text_s25_w700_ls04.copyWith(color: palette.text),
                ),
                AppSpace.h16,
                Padding(
                  padding: AppSpace.ph16,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Мы отправили письмо на почту'.tr(),
                      style: text_s14_w400_ls01.copyWith(color: palette.text60),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' $email',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: ' ${'с проверочным кодом'.tr()}'),
                      ],
                    ),
                  ),
                ),
                Text(
                  'Введите его'.tr(),
                  style: text_s14_w400_ls01.copyWith(color: palette.text60),
                ),
                AppSpace.h24,
                AppSpace.h24,
                PrimaryButton(
                  text: 'Подтвердить создание учетной записи'.tr(),
                  onPress: null,
                ),
                AppSpace.h16,
                Text(
                  'Не пришло письмо? Повторно отправить через TIME сек'.tr(
                    namedArgs: {"time": '59'},
                  ),
                  style: text_s12_w400_ls01.copyWith(color: palette.text60),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
