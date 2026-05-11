import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/user/models/update_user.dart';
import 'package:bogge_app/features/user/notifiers/user_state.dart';
import 'package:bogge_app/features/user/providers/user_provider.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:bogge_app/ui/widgets/containers/dismiss_keyboard_container.dart';
import 'package:bogge_app/ui/widgets/form/reactive_form/reactive_input_field.dart';
import 'package:bogge_app/ui/widgets/headers/common_header.dart';
import 'package:bogge_app/ui/widgets/progress_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:bogge_app/providers/navigation/routers/authorized/authorized_router.gr.dart';

@RoutePage()
class OnboardingNameScreen extends HookConsumerWidget {
  const OnboardingNameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);
    final state = ref.watch(userProvider);
    final userNotifier = ref.watch(userProvider.notifier);
    final isSubmitting = useState(false);

    useEffect(() {
      final name = state?.name;

      if (name != null) {
        userNotifier.userNameForm.control(UserNotifier.nameFieldName).value =
            name;
      }

      final surname = state?.surname;

      if (surname != null) {
        userNotifier.userNameForm.control(UserNotifier.surnameFieldName).value =
            surname;
      }
      return () {};
    }, [state?.name, state?.surname]);

    return Scaffold(
      body: DismissKeyboardContainer(
        child: SafeArea(
          child: Padding(
            padding: AppSpace.ph16,
            child: Column(
              children: [
                CommonHeader(onPop: () => context.router.pop()),
                AppSpace.h24,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ProgressLine(currentIndex: 5)],
                ),
                AppSpace.h32,
                Text(
                  'Как вас зовут'.tr(),
                  style: text_s25_w700_ls04.copyWith(color: palette.text),
                ),
                AppSpace.h16,
                Text(
                  'Это поможет нам рассчитать вашу базальную скорость метаболизма и адаптировать ваш план тренировок'
                      .tr(),
                  style: text_s14_w400_ls01.copyWith(color: palette.text60),
                  textAlign: TextAlign.center,
                ),
                AppSpace.h24,
                ReactiveForm(
                  formGroup: userNotifier.userNameForm,
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReactiveInputField<String>(
                          fieldName: UserNotifier.nameFieldName,
                          keyboardType: TextInputType.text,
                          labelText: 'Имя'.tr(),
                          hiddenErrors: ['required', 'minLength', 'pattern'],
                          inputFormatters: [],
                        ),
                        AppSpace.h8,
                        ReactiveInputField<String>(
                          fieldName: UserNotifier.surnameFieldName,
                          keyboardType: TextInputType.text,
                          labelText: 'Фамилия'.tr(),
                          hiddenErrors: ['required', 'minLength', 'pattern'],
                          inputFormatters: [],
                        ),
                        Spacer(),
                        ReactiveFormConsumer(
                          builder: (context, form, _) => PrimaryButton(
                            text: 'Далее'.tr(),
                            isLoading: isSubmitting.value,
                            onPress: form.valid && !isSubmitting.value
                                ? () => handleSubmit(
                                    context: context,
                                    ref: ref,
                                    isSubmitting: isSubmitting,
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> handleSubmit({
    required BuildContext context,
    required WidgetRef ref,
    required ValueNotifier<bool> isSubmitting,
  }) async {
    isSubmitting.value = true;
    FocusScope.of(context).unfocus();

    final notifier = ref.read(userProvider.notifier);
    notifier.userNameForm.control(UserNotifier.nameFieldName).unfocus();
    notifier.userNameForm.control(UserNotifier.surnameFieldName).unfocus();

    final state = ref.read(userProvider);

    final currentName = state?.name;
    final currentSurname = state?.surname;

    final name =
        notifier.userNameForm
            .control(UserNotifier.nameFieldName)
            .value
            .trim() ??
        '';
    final surname =
        notifier.userNameForm
            .control(UserNotifier.surnameFieldName)
            .value
            .trim() ??
        '';

    if (notifier.userNameForm.invalid) {
      notifier.userNameForm.markAllAsTouched();
      return;
    }

    if (currentName == name && currentSurname == surname) {
      context.router.push(const OnboardingAppleHealthRoute());
      if (context.mounted) {
        isSubmitting.value = false;
      }
      return;
    }

    try {
      final data = UpdateUser(
        name: currentName != name ? name : null,
        surname: currentSurname != surname ? surname : null,
      );

      final newUser = await ref.read(userProvider.notifier).updateUser(data);

      if ((newUser?.name == null || newUser?.surname == null) &&
          context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Что-то пошло не так'.tr())));
        return;
      }

      if (context.mounted) {
        context.router.push(const OnboardingAppleHealthRoute());
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Что-то пошло не так'.tr())));
      }
    } finally {
      if (context.mounted) {
        isSubmitting.value = false;
      }
    }
  }
}
