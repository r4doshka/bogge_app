import 'package:bogge_app/features/auth/models/reset_password_state.dart';
import 'package:bogge_app/features/auth/providers/reset_password_provider.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/widgets/form/requirement_item.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/form/reactive_form/reactive_input_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreateNewPasswordForm extends ConsumerWidget {
  const CreateNewPasswordForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);
    final state = ref.watch(resetPasswordStateProvider);

    return Column(
      children: [
        ReactiveInputField<String>(
          fieldName: state.firstPasswordField,
          labelText: 'Новый пароль'.tr(),
          keyboardType: TextInputType.visiblePassword,
          hiddenErrors: ['minLength', 'required', 'noSpecialChars'],
          obscureText: true,
        ),
        AppSpace.h8,
        ReactiveFormConsumer(
          builder: (context, form, _) {
            final passwordControl = form.control(
              ResetPasswordState.firstPasswordFieldName,
            );

            final hasNoSpecialChars = !passwordControl.hasError(
              'noSpecialChars',
            );
            final hasMinLength = !passwordControl.hasError('minLength');

            return Padding(
              padding: AppSpace.ph16,
              child: Column(
                children: [
                  RequirementItem(
                    isValid: hasMinLength,
                    svgColor: hasMinLength ? palette.delete : palette.peach,
                    text: 'Минимум 8 символов'.tr(),
                  ),
                  AppSpace.h4,
                  RequirementItem(
                    isValid: hasNoSpecialChars,
                    svgColor: hasNoSpecialChars
                        ? palette.delete
                        : palette.peach,
                    text: 'Без специальных знаков'.tr(),
                  ),
                  AppSpace.h8,
                ],
              ),
            );
          },
        ),
        ReactiveInputField<String>(
          fieldName: state.secondPasswordField,
          labelText: 'Повторите пароль'.tr(),
          keyboardType: TextInputType.visiblePassword,
          hiddenErrors: ['minLength', 'required', 'noSpecialChars'],
          obscureText: true,
        ),

        ReactiveFormConsumer(
          builder: (context, form, _) {
            final second = form.control(
              ResetPasswordState.secondPasswordFieldName,
            );

            final hasError = form.hasError('passwordsNotMatch');

            return Column(
              children: [
                if (hasError && second.dirty) ...[
                  AppSpace.h8,
                  RequirementItem(
                    isValid: false,
                    text: 'Пароли не совпадают'.tr(),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
