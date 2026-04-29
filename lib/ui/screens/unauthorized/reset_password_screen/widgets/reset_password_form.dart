import 'package:bogge_app/features/auth/models/reset_password_state.dart';
import 'package:bogge_app/features/auth/providers/reset_password_provider.dart';
import 'package:bogge_app/ui/widgets/form/requirement_item.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/form/reactive_form/reactive_input_field.dart';
import 'package:bogge_app/utils/formatters/email_input_formatter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ResetPasswordForm extends ConsumerWidget {
  const ResetPasswordForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resetPasswordStateProvider);

    return Column(
      children: [
        ReactiveInputField<String>(
          fieldName: state.emailField,
          keyboardType: TextInputType.emailAddress,
          labelText: 'Адрес электронной почты'.tr(),
          inputFormatters: [EmailInputFormatter()],
          hiddenErrors: ['email', 'required'],
        ),
        AppSpace.h8,
        ReactiveFormConsumer(
          builder: (context, form, _) {
            final emailControl = form.control(
              ResetPasswordState.emailFieldName,
            );
            return Padding(
              padding: AppSpace.ph16,
              child: Column(
                children: [
                  if (emailControl.hasErrors && emailControl.touched)
                    RequirementItem(
                      isValid: false,
                      text: 'Неверный Email'.tr(),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
