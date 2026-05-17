import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/user/models/update_user.dart';
import 'package:bogge_app/features/user/notifiers/user_state.dart';
import 'package:bogge_app/features/user/providers/user_provider.dart';
import 'package:bogge_app/models/router/router_model.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/check_button.dart';
import 'package:bogge_app/ui/widgets/form/date_picker.dart';
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

Future<void> showEditAgeModalBottom({required BuildContext context}) async {
  final mediaQuery = MediaQuery.of(context);
  return await showDefaultModalBottom(
    context: context,
    minHeight: mediaQuery.size.height * 0.94,
    hasCloseButton: false,
    modalName: AppModalList.editAge.title,
    child: EditAgeModal(),
  );
}

class EditAgeModal extends HookConsumerWidget {
  const EditAgeModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);
    final state = ref.watch(userProvider);
    final userNotifier = ref.watch(userProvider.notifier);
    final isSubmitting = useState(false);

    final showDatePicker = useState(false);
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
    }, []);

    return Padding(
      padding: AppSpace.ph16,
      child: ReactiveForm(
        formGroup: userNotifier.dateOfBirthForm,
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
                    label: 'Дата рождения'.tr(),
                    textStyle: text_s17_w600_lsm043.copyWith(
                      color: palette.text,
                    ),
                  ),
                ),
                ReactiveFormConsumer(
                  builder: (context, form, _) => CheckButton(
                    onPress: form.valid && !isSubmitting.value
                        ? () => handleSubmit(
                            context: context,
                            ref: ref,
                            isSubmitting: isSubmitting,
                            currentDate: currentDate.value,
                          )
                        : null,
                  ),
                ),
              ],
            ),
            AppSpace.h32,

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
                            .control(UserNotifier.dateOfBirthFieldName)
                            .value =
                        formatted;

                    userNotifier.dateOfBirthForm
                        .control(UserNotifier.dateOfBirthFieldName)
                        .markAsTouched();
                  }
                },
              ),
            ],

            AppSpace.h16,
            Text(
              'Здесь вы можете изменить дату своего рождения'.tr(),
              style: text_s14_w400_ls01.copyWith(color: palette.text60),
              textAlign: TextAlign.center,
            ),
          ],
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

    final notifier = ref.read(userProvider.notifier);

    final isDateChanged = notifier.isDateOfBirthChanged(currentDate);
    if (!isDateChanged && context.mounted) {
      return;
    }

    try {
      isSubmitting.value = true;
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
        context.router.pop();
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
