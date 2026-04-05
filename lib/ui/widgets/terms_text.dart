import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/modals/privacy_policy_modal.dart';
import 'package:bogge_app/ui/widgets/modals/user_agreement_modal.dart';
import 'package:bogge_app/utils/const.dart';
import 'package:bogge_app/utils/lounch_url.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TermsText extends ConsumerWidget {
  final Color? color;
  final TextStyle? textStyle;
  final TextAlign? textAlign;

  const TermsText({super.key, this.color, this.textStyle, this.textAlign});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);
    final currentTextStyle = textStyle ?? text_s12_w400_ls01;

    return RichText(
      textAlign: textAlign ?? TextAlign.center,
      text: TextSpan(
        text: 'Продолжая, вы подтверждаете, что понимаете и соглашаетесь с'
            .tr(),
        style: currentTextStyle.copyWith(color: color ?? palette.gray3),
        children: <TextSpan>[
          TextSpan(
            text: ' ${'Пользовательским соглашением'.tr()}',
            style: TextStyle(decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () => showUserAgreementModalBottom(context: context),
          ),
          TextSpan(
            text: ' ${'и'.tr()}',
            style: TextStyle(color: color ?? palette.gray3),
          ),
          TextSpan(
            text: ' ${'Политикой конфиденциальности'.tr()}',
            style: TextStyle(decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () => showPrivacyPolicyModalBottom(context: context),
          ),
        ],
      ),
    );
  }
}
