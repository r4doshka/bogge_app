import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/auth/providers/sign_up_provider.dart';
import 'package:bogge_app/ui/screens/unauthorized/sign_up_screen/widgets/sign_up_form.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:bogge_app/ui/widgets/containers/dismiss_keyboard_container.dart';
import 'package:bogge_app/ui/widgets/headers/common_header.dart';
import 'package:bogge_app/ui/widgets/terms_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signUpStateProvider);

    return Scaffold(
      body: DismissKeyboardContainer(
        child: SafeArea(
          child: Padding(
            padding: AppSpace.ph16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonHeader(title: 'Регистрация'.tr()),
                AppSpace.h24,
                ReactiveForm(
                  formGroup: state.signUpForm,
                  child: Column(
                    children: [
                      SignUpForm(
                        onEmailChange: (val) {
                          print('onEmailChange ==> ${val?.value}');
                        },
                        onPasswordChange: (val) {
                          print('onPasswordChange ==> ${val?.value}');
                        },
                      ),
                      AppSpace.h32,
                      ReactiveFormConsumer(
                        builder: (context, form, child) {
                          return PrimaryButton(
                            text: 'Создать учетную запись'.tr(),
                            onPress: form.valid && form.dirty ? () {} : null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                AppSpace.h16,
                Padding(padding: AppSpace.ph16, child: TermsText()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
