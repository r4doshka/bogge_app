import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/providers/navigation/routers/un_authorized/un_authorized_router.gr.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/screens/unauthorized/sign_in_screen/widgets/sign_in_form.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_text_button.dart';
import 'package:bogge_app/ui/widgets/buttons/text_button_with_icon.dart';
import 'package:bogge_app/ui/widgets/containers/dismiss_keyboard_container.dart';
import 'package:bogge_app/ui/widgets/headers/common_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);

    return Scaffold(
      body: DismissKeyboardContainer(
        child: SafeArea(
          child: Padding(
            padding: AppSpace.ph16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonHeader(title: 'Вход'.tr()),
                AppSpace.h24,
                SignInForm(
                  onEmailChange: (val) {
                    print('onEmailChange ==> ${val?.value}');
                  },
                  onPasswordChange: (val) {
                    print('onPasswordChange ==> ${val?.value}');
                  },
                ),
                AppSpace.h16,
                PrimaryTextButton(
                  text: 'Забыли пароль?'.tr(),
                  onPress: () => context.router.push(ResetPasswordRoute()),
                ),
                AppSpace.h32,
                PrimaryButton(text: 'Войти'.tr(), onPress: null),
                AppSpace.h16,
                Center(
                  child: TextButtonWithIcon(
                    text: 'Войти как гость'.tr(),
                    renderIconLeft: () => Padding(
                      padding: EdgeInsetsDirectional.only(end: AppSpace.s4.w),
                      child: SvgPicture.asset('assets/icons/guest-icon.svg'),
                    ),
                    onPress: () => context.router.push(ResetPasswordRoute()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
