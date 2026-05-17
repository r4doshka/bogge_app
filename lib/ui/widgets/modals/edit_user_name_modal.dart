import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/user/models/update_user.dart';
import 'package:bogge_app/features/user/notifiers/user_state.dart';
import 'package:bogge_app/features/user/providers/user_provider.dart';
import 'package:bogge_app/models/router/router_model.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/check_button.dart';
import 'package:bogge_app/ui/widgets/containers/dismiss_keyboard_container.dart';
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

Future<void> showEditUserNameModalBottom({
  required BuildContext context,
}) async {
  final mediaQuery = MediaQuery.of(context);
  return await showDefaultModalBottom(
    context: context,
    minHeight: mediaQuery.size.height * 0.94,
    hasCloseButton: false,
    modalName: AppModalList.editUserName.title,
    child: DismissKeyboardContainer(child: EditUserNameModal()),
  );
}

class EditUserNameModal extends HookConsumerWidget {
  const EditUserNameModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);
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
    }, []);

    return Padding(
      padding: AppSpace.ph16,
      child: ReactiveForm(
        formGroup: userNotifier.userNameForm,
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
                    label: 'Имя'.tr(),
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
                          )
                        : null,
                  ),
                ),
              ],
            ),
            AppSpace.h32,
            ReactiveInputField<String>(
              fieldName: UserNotifier.nameFieldName,
              keyboardType: TextInputType.text,
              labelText: 'Имя'.tr(),
              hiddenErrors: ['required', 'minLength', 'pattern'],
            ),
            AppSpace.h8,
            ReactiveInputField<String>(
              fieldName: UserNotifier.surnameFieldName,
              keyboardType: TextInputType.text,
              labelText: 'Фамилия'.tr(),
              hiddenErrors: ['required', 'minLength', 'pattern'],
            ),
            AppSpace.h16,
            Text(
              'Здесь вы можете изменить Имя и Фамилию пользователя'.tr(),
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
    required ValueNotifier<bool> isSubmitting,
  }) async {
    isSubmitting.value = true;
    final notifier = ref.read(userProvider.notifier);
    FocusScope.of(context).unfocus();
    notifier.userNameForm.unfocus();

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
      return;
    }

    if (currentName == name && currentSurname == surname) {
      context.router.pop();
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
        notifier.userNameForm.reset();
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
