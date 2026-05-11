import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/user/models/update_user.dart';
import 'package:bogge_app/features/user/notifiers/user_state.dart';
import 'package:bogge_app/features/user/providers/user_provider.dart';
import 'package:bogge_app/providers/navigation/routers/authorized/authorized_router.gr.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:bogge_app/ui/widgets/containers/dismiss_keyboard_container.dart';
import 'package:bogge_app/ui/widgets/form/date_picker.dart';
import 'package:bogge_app/ui/widgets/form/reactive_form/reactive_input_field.dart';
import 'package:bogge_app/ui/widgets/headers/common_header.dart';
import 'package:bogge_app/ui/widgets/progress_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

@RoutePage()
class OnboardingAgeScreen extends HookConsumerWidget {
  const OnboardingAgeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);
    final userNotifier = ref.watch(userProvider.notifier);
    final state = ref.watch(userProvider);

    final isSubmitting = useState(false);
    final showDatePicker = useState(state?.dateOfBirth != null);
    final currentDate = useState<DateTime?>(state?.dateOfBirth);
    final localeCode = context.locale.languageCode;

    useEffect(() {
      final date = state?.dateOfBirth;

      if (date != null) {
        final formatted = DateFormat('d MMMM yyyy', localeCode).format(date);

        userNotifier.dateOfBirthForm
                .control(UserNotifier.dateOfBirthFieldName)
                .value =
            formatted;
      }
      return () {};
    }, [state?.dateOfBirth, localeCode]);

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
                  children: [ProgressLine(currentIndex: 2)],
                ),
                AppSpace.h32,
                Text(
                  'Каков ваш возраст'.tr(),
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
                  formGroup: userNotifier.dateOfBirthForm,
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => showDatePicker.value = true,
                          child: AbsorbPointer(
                            child: ReactiveInputField<String>(
                              fieldName: UserNotifier.dateOfBirthFieldName,
                              keyboardType: TextInputType.datetime,
                              labelText: 'Дата рождения'.tr(),
                              hiddenErrors: ['required'],
                              inputFormatters: [],
                            ),
                          ),
                        ),

                        if (showDatePicker.value) ...[
                          AppSpace.h8,
                          DatePicker(
                            initialValue: [currentDate.value],
                            onValueChanged: (val) {
                              if (val.isNotEmpty && val[0] != null) {
                                final date = val[0]!;
                                currentDate.value = date;

                                final formatted = DateFormat(
                                  'd MMMM yyyy',
                                  context.locale.languageCode,
                                ).format(date);

                                userNotifier.dateOfBirthForm
                                        .control(
                                          UserNotifier.dateOfBirthFieldName,
                                        )
                                        .value =
                                    formatted;

                                userNotifier.dateOfBirthForm
                                    .control(UserNotifier.dateOfBirthFieldName)
                                    .markAsTouched();
                              }
                            },
                          ),
                        ],
                        Spacer(),
                        ReactiveFormConsumer(
                          builder: (context, form, _) => PrimaryButton(
                            text: 'Далее'.tr(),
                            isLoading: isSubmitting.value,
                            onPress:
                                form.valid &&
                                    currentDate.value != null &&
                                    !isSubmitting.value
                                ? () => handleSubmit(
                                    context: context,
                                    ref: ref,
                                    currentDate: currentDate.value,
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
    required DateTime? currentDate,
    required ValueNotifier<bool> isSubmitting,
  }) async {
    if (currentDate == null) return;

    isSubmitting.value = true;

    final notifier = ref.read(userProvider.notifier);

    final isDateChanged = notifier.isDateOfBirthChanged(currentDate);
    if (!isDateChanged) {
      context.router.push(const OnboardingHeightRoute());
      if (context.mounted) {
        isSubmitting.value = false;
      }
      return;
    }

    try {
      final selectedIso = DateFormat('yyyy-MM-dd').format(currentDate);

      final data = UpdateUser(dateOfBirth: selectedIso);

      final newUser = await ref.read(userProvider.notifier).updateUser(data);

      if (newUser?.dateOfBirth == null && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Что-то пошло не так'.tr())));
        return;
      }

      if (context.mounted) {
        context.router.push(const OnboardingHeightRoute());
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
