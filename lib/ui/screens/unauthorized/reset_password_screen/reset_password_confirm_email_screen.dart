import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/auth/api/auth_api.dart';
import 'package:bogge_app/features/auth/models/reset_password_state.dart';
import 'package:bogge_app/features/auth/providers/reset_password_provider.dart';
import 'package:bogge_app/helpers/handle_request_failure.dart';
import 'package:bogge_app/models/request_error_model.dart';
import 'package:bogge_app/providers/navigation/routers/un_authorized/un_authorized_router.gr.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/containers/dismiss_keyboard_container.dart';
import 'package:bogge_app/ui/widgets/form/pin_code_fields.dart';
import 'package:bogge_app/ui/widgets/headers/common_header.dart';
import 'package:bogge_app/ui/widgets/resend_timer_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class ResetPasswordConformEmailScreen extends HookConsumerWidget {
  final String email;
  const ResetPasswordConformEmailScreen({required this.email, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);
    final stateNotifier = ref.read(resetPasswordStateProvider.notifier);
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
                PinCodeFields(
                  errorText: state.confirmCodeErrors,
                  controller: stateNotifier.pinController,
                  onChanged: stateNotifier.updateConfirmCode,
                  onComplete: (_) => isSubmitting.value
                      ? null
                      : handleSubmit(
                          context: context,
                          ref: ref,
                          isSubmitting: isSubmitting,
                        ),
                ),
                AppSpace.h24,
                ResendTimer(
                  () => handleResendCode(context: context, ref: ref),
                  state.resetPasswordForm
                      .control(ResetPasswordState.emailFieldName)
                      .value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleResendCode({
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      final response = await ref.read(authRepository).forgotPassword();
      final state = ref.watch(resetPasswordStateProvider.notifier);
      state.clearConfirmCodeFlow();

      if (!context.mounted) return;

      if (!response.success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Что-то пошло не так'.tr())));
        return;
      }
    } on RequestErrorModel catch (e) {
      if (!context.mounted) return;
      handleRequestFailure(context: context, failureType: e.failureType);
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Что-то пошло не так'.tr())));
    }
  }

  void handleSubmit({
    required WidgetRef ref,
    required BuildContext context,
    required ValueNotifier<bool> isSubmitting,
  }) async {
    try {
      FocusScope.of(context).unfocus();
      isSubmitting.value = true;
      final stateNotifier = ref.read(resetPasswordStateProvider.notifier);

      final isValid = stateNotifier.validateConfirmCode();
      if (!isValid) return;

      context.router.push(CreateNewPasswordRoute());
    } catch (_) {
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
