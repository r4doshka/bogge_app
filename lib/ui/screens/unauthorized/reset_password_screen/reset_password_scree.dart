import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/containers/dismiss_keyboard_container.dart';
import 'package:bogge_app/ui/widgets/headers/common_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class ResetPasswordScreen extends ConsumerWidget {
  const ResetPasswordScreen({super.key});

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
                  'Восстановление пароля'.tr(),
                  style: text_s25_w700_ls04.copyWith(color: palette.text),
                ),
                AppSpace.h16,
                Text(
                  'Введите email который вы использовали при регистрации Мы отправим инструкции для сброса пароля'
                      .tr(),
                  style: text_s14_w400_ls01.copyWith(color: palette.text60),
                  textAlign: TextAlign.center,
                ),
                AppSpace.h24,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
