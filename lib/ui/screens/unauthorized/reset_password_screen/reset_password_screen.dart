import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/auth/api/auth_api.dart';
import 'package:bogge_app/features/auth/api/backend_success_code_parser.dart';
import 'package:bogge_app/features/auth/models/reset_password_state.dart';
import 'package:bogge_app/features/auth/providers/reset_password_provider.dart';
import 'package:bogge_app/helpers/handle_request_failure.dart';
import 'package:bogge_app/models/request_error_model.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/screens/unauthorized/reset_password_screen/widgets/reset_password_form.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:bogge_app/ui/widgets/containers/dismiss_keyboard_container.dart';
import 'package:bogge_app/ui/widgets/headers/common_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class ResetPasswordScreen extends HookConsumerWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);
    final state = ref.watch(resetPasswordStateProvider);
    final isSubmitting = useState(false);

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
                ReactiveForm(
                  formGroup: state.resetPasswordForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ResetPasswordForm(),
                      AppSpace.h32,
                      ReactiveFormConsumer(
                        builder: (context, form, _) {
                          return PrimaryButton(
                            text: 'Отправить письмо'.tr(),
                            isLoading: isSubmitting.value,
                            onPress: form.valid && !isSubmitting.value
                                ? () => handleSubmit(
                                    context: context,
                                    ref: ref,
                                    form: form,
                                    isSubmitting: isSubmitting,
                                  )
                                : null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleSubmit({
    required BuildContext context,
    required WidgetRef ref,
    required FormGroup form,
    required ValueNotifier<bool> isSubmitting,
  }) async {
    try {
      FocusScope.of(context).unfocus();
      isSubmitting.value = true;
      final state = ref.read(resetPasswordStateProvider);
      state.resetPasswordForm.unfocus();

      final String email = state.resetPasswordForm
          .control(ResetPasswordState.emailFieldName)
          .value;

      final response = await ref.read(authRepository).forgotPassword();

      if (!context.mounted) return;

      if (!response.success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Что-то пошло не так'.tr())));
        return;
      }

      handleFormSuccess(
        context: context,
        code: AuthSuccessCodeX.fromCode(response.code),
        email: email,
      );
    } on RequestErrorModel catch (e) {
      if (!context.mounted) return;

      handleRequestFailure(context: context, failureType: e.failureType);
    } catch (error, _) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Что-то пошло не так'.tr())));
    } finally {
      if (context.mounted) {
        isSubmitting.value = false;
      }
    }
  }
}
