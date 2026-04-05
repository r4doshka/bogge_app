import 'package:bogge_app/features/auth/providers/sign_up_provider.dart';
import 'package:bogge_app/ui/screens/unauthorized/sign_up_screen/widgets/requirment_item.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/form/reactive_form/reactive_input_field.dart';
import 'package:bogge_app/utils/formatters/email_input_formatter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SignUpForm extends ConsumerWidget {
  final void Function(FormControl<String>?)? onEmailChange;
  final void Function(FormControl<String>?)? onPasswordChange;

  const SignUpForm({
    required this.onEmailChange,
    required this.onPasswordChange,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signUpStateProvider);

    return ReactiveValueListenableBuilder<String>(
      formControlName: state.passwordField,
      builder: (context, control, child) {
        final hasNoSpecialChars = !control.hasError('noSpecialChars');
        final hasMinLength = !control.hasError('minLength');

        return Column(
          children: [
            ReactiveInputField<String>(
              fieldName: state.emailField,
              keyboardType: TextInputType.emailAddress,
              labelText: 'Адрес электронной почты'.tr(),
              inputFormatters: [EmailInputFormatter()],
              hiddenErrors: ['required'],
              validationMessages: {
                ValidationMessage.email: (_) => 'Неверный Email'.tr(),
              },
              onChanged: onEmailChange,
            ),
            AppSpace.h8,
            ReactiveInputField<String>(
              fieldName: state.passwordField,
              obscureText: true,
              labelText: 'Пароль'.tr(),
              keyboardType: TextInputType.visiblePassword,
              hiddenErrors: ['minLength', 'required'],
              validationMessages: {
                ValidationMessage.minLength: (_) =>
                    'Пароль не соответствует требованиям'.tr(),
              },
              onChanged: onPasswordChange,
            ),
            AppSpace.h8,
            RequirementItem(
              isValid: hasMinLength,
              text: 'Минимум 8 символов'.tr(),
            ),
            AppSpace.h4,
            RequirementItem(
              isValid: hasNoSpecialChars,
              text: 'Без специальных знаков'.tr(),
            ),
          ],
        );
      },
    );
  }
}
