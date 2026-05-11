import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/auth/api/auth_api.dart';
import 'package:bogge_app/features/auth/providers/reset_password_provider.dart';
import 'package:bogge_app/helpers/handle_request_failure.dart';
import 'package:bogge_app/models/request_error_model.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/services/navigation_service.dart';
import 'package:bogge_app/ui/screens/unauthorized/reset_password_screen/widgets/create_new_password_form.dart';
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
class CreateNewPasswordScreen extends HookConsumerWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);
    final state = ref.watch(resetPasswordStateProvider);
    final stateNotifier = ref.read(resetPasswordStateProvider.notifier);
    final isSubmitting = useState(false);

    return Scaffold(
      body: DismissKeyboardContainer(
        child: SafeArea(
          child: Padding(
            padding: AppSpace.ph16,
            child: Column(
              children: [
                CommonHeader(
                  onPop: () {
                    stateNotifier.clearNewPasswordFlow();
                    stateNotifier.clearConfirmCodeFlow();
                    context.pop();
                  },
                ),
                AppSpace.h16,
                Text(
                  'Создайте новый пароль'.tr(),
                  style: text_s25_w700_ls04.copyWith(color: palette.text),
                ),
                AppSpace.h16,
                Text(
                  'Придумайте надёжный пароль, который вы не использовали ранее'
                      .tr(),
                  style: text_s14_w400_ls01.copyWith(color: palette.text60),
                  textAlign: TextAlign.center,
                ),
                AppSpace.h24,
                ReactiveForm(
                  formGroup: state.createNewPasswordForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CreateNewPasswordForm(),
                      AppSpace.h24,
                      ReactiveFormConsumer(
                        builder: (context, form, _) {
                          return PrimaryButton(
                            text: 'Сохранить и войти'.tr(),
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
      isSubmitting.value = true;
      FocusScope.of(context).unfocus();
      final response = await ref.read(authRepository).resetPassword();

      if (!context.mounted) return;

      if (!response.success) {
        final stateNotifier = ref.read(resetPasswordStateProvider.notifier);
        stateNotifier.clearNewPasswordFlow();
        stateNotifier.clearConfirmCodeFlow();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Что-то пошло не так'.tr())));
        context.pop();
        return;
      }
      final navigationService = ref.read(navigationServiceProvider);
      navigationService.goToAuthorizedMode(context);
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
