import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/auth/api/auth_api.dart';
import 'package:bogge_app/features/auth/models/sign_up_state.dart';
import 'package:bogge_app/features/auth/providers/sign_up_provider.dart';
import 'package:bogge_app/features/auth/api/backend_success_code_parser.dart';
import 'package:bogge_app/helpers/handle_request_failure.dart';
import 'package:bogge_app/models/request_error_model.dart';
import 'package:bogge_app/ui/screens/unauthorized/sign_up_screen/widgets/sign_up_form.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:bogge_app/ui/widgets/containers/dismiss_keyboard_container.dart';
import 'package:bogge_app/ui/widgets/headers/common_header.dart';
import 'package:bogge_app/ui/widgets/terms_text.dart';
import 'package:bogge_app/features/auth/api/backend_error_code_parser.dart';
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
                      SignUpForm(),
                      AppSpace.h32,
                      ReactiveFormConsumer(
                        builder: (context, form, child) {
                          return PrimaryButton(
                            text: 'Создать учетную запись'.tr(),
                            onPress: form.valid && form.dirty
                                ? () => handleSubmit(
                                    context: context,
                                    ref: ref,
                                    form: form,
                                  )
                                : null,
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

  void handleSubmit({
    required BuildContext context,
    required WidgetRef ref,
    required FormGroup form,
  }) async {
    try {
      final state = ref.read(signUpStateProvider);
      final String email = state.signUpForm
          .control(SignUpState.emailFieldName)
          .value;

      final response = await ref.read(authRepository).signUp();

      if (!context.mounted) return;

      if (!response.success) {
        handleFormError(
          code: BackendErrorCodeX.fromCode(response.code),
          form: form,
          context: context,
        );
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
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Что-то пошло не так'.tr())));
    }
  }
}
