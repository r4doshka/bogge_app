import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/auth/api/auth_api.dart';
import 'package:bogge_app/features/auth/api/backend_error_code_parser.dart';
import 'package:bogge_app/features/auth/models/change_email_state.dart';
import 'package:bogge_app/features/auth/providers/change_email_provider.dart';
import 'package:bogge_app/features/user/providers/user_provider.dart';
import 'package:bogge_app/models/router/router_model.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/check_button.dart';
import 'package:bogge_app/ui/widgets/containers/dismiss_keyboard_container.dart';
import 'package:bogge_app/ui/widgets/form/pin_code_fields.dart';
import 'package:bogge_app/ui/widgets/form/reactive_form/reactive_input_field.dart';
import 'package:bogge_app/ui/widgets/modals/widgets/default_modal_bottom.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/modals/widgets/modal_close_button.dart';
import 'package:bogge_app/ui/widgets/modals/widgets/modal_title.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

Future<void> showEditUserEmailModalBottom({
  required BuildContext context,
}) async {
  final mediaQuery = MediaQuery.of(context);
  return await showDefaultModalBottom(
    context: context,
    minHeight: mediaQuery.size.height * 0.94,
    hasCloseButton: false,
    modalName: AppModalList.editUserName.title,
    child: DismissKeyboardContainer(child: EditUserEmailContainer()),
  );
}

class EditUserEmailContainer extends HookConsumerWidget {
  const EditUserEmailContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = useState(1);
    final navigatedFromConfirm = useState(false);

    if (currentStep.value == 1) {
      return EditUserEmailStep(
        onNext: () => currentStep.value = 2,
        navigatedFromConfirm: navigatedFromConfirm.value,
      );
    }

    return ConfirmCodeStep(
      onBackNavigate: () {
        currentStep.value = 1;
        navigatedFromConfirm.value = true;
      },
    );
  }
}

class ConfirmCodeStep extends HookConsumerWidget {
  final void Function() onBackNavigate;

  const ConfirmCodeStep({super.key, required this.onBackNavigate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);

    final stateNotifier = ref.read(changeEmailStateProvider.notifier);
    final state = ref.watch(changeEmailStateProvider);
    final isSubmitting = useState(false);

    return Padding(
      padding: AppSpace.ph16,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: AppSpace.s44.w,
                child: Container(
                  alignment: AlignmentDirectional.centerStart,
                  height: AppSpace.s44.h,
                  width: AppSpace.s44.w,
                  child: ModalCloseButton(onClose: onBackNavigate),
                ),
              ),
              Expanded(
                child: ModalTitle(
                  label: 'Почта'.tr(),
                  textStyle: text_s17_w600_lsm043.copyWith(color: palette.text),
                ),
              ),
              CheckButton(
                onPress: () =>
                    isSubmitting.value && state.confirmCodeErrors == null
                    ? null
                    : handleSubmit(
                        context: context,
                        ref: ref,
                        isSubmitting: isSubmitting,
                      ),
              ),
            ],
          ),
          AppSpace.h16,
          Text(
            'Проверочный код'.tr(),
            style: text_s17_w600_lsm043.copyWith(color: palette.text),
          ),
          AppSpace.h8,
          Text(
            'Мы отправили вам на почту проверочный код'.tr(),
            style: text_s14_w400_ls01.copyWith(color: palette.text60),
          ),
          Text(
            'Введите его'.tr(),
            style: text_s14_w400_ls01.copyWith(color: palette.text60),
          ),
          AppSpace.h32,
          PinCodeFields(
            errorText: state.confirmCodeErrors,
            controller: stateNotifier.pinController,
            onChanged: stateNotifier.updateConfirmCode,
          ),
        ],
      ),
    );
  }

  void handleSubmit({
    required WidgetRef ref,
    required BuildContext context,
    required ValueNotifier<bool> isSubmitting,
  }) async {
    try {
      FocusScope.of(context).unfocus();
      isSubmitting.value = true;
      final stateNotifier = ref.read(changeEmailStateProvider.notifier);

      final isValid = stateNotifier.validateConfirmCode();
      if (!isValid) return;

      final response = await ref.read(authRepository).confirmUpdateEmail();

      if (!response.success) {
        if (response.errorCode == AuthBackendErrorCode.unknown) {
          final form = ref.read(changeEmailStateProvider).userEmailForm;
          final control = form.control(ChangeEmailState.emailFieldName);

          control.setErrors({"common": true});
          control.markAsTouched();
          stateNotifier.pinController.clear();
          onBackNavigate();
          return;
        }
        stateNotifier.setConfirmCodeError();
        return;
      }
      if (!context.mounted) return;
      context.router.pop();
    } catch (_) {
      if (!context.mounted) return;
      onBackNavigate();
    } finally {
      if (context.mounted) {
        isSubmitting.value = false;
      }
    }
  }
}

class EditUserEmailStep extends HookConsumerWidget {
  final bool navigatedFromConfirm;
  final void Function() onNext;

  const EditUserEmailStep({
    super.key,
    required this.onNext,
    required this.navigatedFromConfirm,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);
    final user = ref.watch(userProvider);
    final state = ref.watch(changeEmailStateProvider);
    final isSubmitting = useState(false);

    useEffect(() {
      if (navigatedFromConfirm) return () {};
      final name = user?.email;

      if (name != null) {
        state.userEmailForm.control(ChangeEmailState.emailFieldName).value =
            name;
      }
      return () {};
    }, []);

    return Padding(
      padding: AppSpace.ph16,
      child: ReactiveForm(
        formGroup: state.userEmailForm,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: AppSpace.s44.w,
                  child: Container(
                    alignment: AlignmentDirectional.centerStart,
                    height: AppSpace.s44.h,
                    width: AppSpace.s44.w,
                    child: ModalCloseButton(),
                  ),
                ),
                Expanded(
                  child: ModalTitle(
                    label: 'Почта'.tr(),
                    textStyle: text_s17_w600_lsm043.copyWith(
                      color: palette.text,
                    ),
                  ),
                ),
                ReactiveFormConsumer(
                  builder: (context, form, _) => CheckButton(
                    onPress: form.valid && !isSubmitting.value
                        ? () => getConformCode(
                            context: context,
                            ref: ref,
                            isSubmitting: isSubmitting,
                          )
                        : null,
                  ),
                ),
              ],
            ),
            AppSpace.h32,
            ReactiveInputField<String>(
              fieldName: ChangeEmailState.emailFieldName,
              keyboardType: TextInputType.text,
              labelText: 'Адрес электронной почты'.tr(),
              hiddenErrors: ['required', 'email', 'pattern'],
              validationMessages: {
                'userAlreadyExists': (_) => 'Почта уже занята'.tr(),
                'common': (_) => 'Что-то пошло не так'.tr(),
              },
            ),
            AppSpace.h16,
            Text(
              'Здесь вы можете изменить адрес электронной почты пользователя'
                  .tr(),
              style: text_s14_w400_ls01.copyWith(color: palette.text60),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getConformCode({
    required BuildContext context,
    required WidgetRef ref,
    required ValueNotifier<bool> isSubmitting,
  }) async {
    final user = ref.watch(userProvider);
    final state = ref.watch(changeEmailStateProvider);
    FocusScope.of(context).unfocus();
    state.userEmailForm.unfocus();

    final currentEmail = user?.email;

    final newEmail =
        state.userEmailForm
            .control(ChangeEmailState.emailFieldName)
            .value
            .trim() ??
        '';

    if (state.userEmailForm.invalid) {
      return;
    }

    if (currentEmail == newEmail) {
      context.router.pop();
      return;
    }

    try {
      isSubmitting.value = true;
      final response = await ref
          .read(authRepository)
          .getUpdateEmailConfirmCode();

      if (!response.success && context.mounted) {
        if (response.errorCode == AuthBackendErrorCode.userAlreadyExists ||
            response.errorCode == AuthBackendErrorCode.emailAlreadyInUse) {
          state.userEmailForm
              .control(ChangeEmailState.emailFieldName)
              .setErrors({"userAlreadyExists": true});

          state.userEmailForm
              .control(ChangeEmailState.emailFieldName)
              .markAsTouched();
          return;
        }
      }
      onNext();
    } catch (e) {
      state.userEmailForm.control(ChangeEmailState.emailFieldName).setErrors({
        "common": true,
      });

      state.userEmailForm
          .control(ChangeEmailState.emailFieldName)
          .markAsTouched();
    } finally {
      if (context.mounted) {
        isSubmitting.value = false;
      }
    }
  }
}
