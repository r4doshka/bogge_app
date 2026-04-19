import 'package:bogge_app/features/auth/providers/sign_in_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/form/reactive_form/reactive_input_field.dart';
import 'package:bogge_app/utils/formatters/email_input_formatter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SignInForm extends ConsumerWidget {
  final void Function(FormControl<String>?)? onEmailChange;
  final void Function(FormControl<String>?)? onPasswordChange;

  const SignInForm({
    required this.onEmailChange,
    required this.onPasswordChange,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signInStateProvider);

    return ReactiveForm(
      formGroup: state.signInForm,
      child: Column(
        children: [
          ReactiveInputField<String>(
            fieldName: state.emailField,
            keyboardType: TextInputType.emailAddress,
            labelText: 'Адрес электронной почты'.tr(),
            inputFormatters: [EmailInputFormatter()],
            validationMessages: {
              ValidationMessage.email: (_) => 'Неверный Email'.tr(),
            },
            onChanged: onEmailChange,
          ),
          AppSpace.h8,
          ReactiveInputField<String>(
            fieldName: state.passwordField,
            labelText: 'Пароль'.tr(),
            keyboardType: TextInputType.visiblePassword,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
            ],
            onChanged: onPasswordChange,
          ),
        ],
      ),
    );
  }
}
