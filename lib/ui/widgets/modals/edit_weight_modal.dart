import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/user/models/update_user.dart';
import 'package:bogge_app/features/user/notifiers/user_state.dart';
import 'package:bogge_app/features/user/providers/user_provider.dart';
import 'package:bogge_app/models/router/router_model.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/check_button.dart';
import 'package:bogge_app/ui/widgets/form/reactive_form/reactive_input_field.dart';
import 'package:bogge_app/ui/widgets/modals/widgets/default_modal_bottom.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/modals/widgets/modal_close_button.dart';
import 'package:bogge_app/ui/widgets/modals/widgets/modal_title.dart';
import 'package:bogge_app/ui/widgets/weight_ruler_picker.dart';
import 'package:bogge_app/utils/is_same_double.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

Future<void> showEditWeightModalBottom({required BuildContext context}) async {
  final mediaQuery = MediaQuery.of(context);
  return await showDefaultModalBottom(
    context: context,
    minHeight: mediaQuery.size.height * 0.94,
    hasCloseButton: false,
    shrinkWrap: false,
    modalName: AppModalList.editWeight.title,
    contentRenderer: () => EditWeightModal(),
    child: const SizedBox(),
  );
}

class EditWeightModal extends HookConsumerWidget {
  const EditWeightModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);
    final state = ref.watch(userProvider);
    final userNotifier = ref.watch(userProvider.notifier);
    final currentWeight = useState<double>(state?.weight ?? 65.0);
    final isSubmitting = useState(false);

    useEffect(() {
      final height = state?.height;

      if (height != null) {
        userNotifier.weightForm.control(UserNotifier.weightFieldName).value =
            state?.formattedWeight ?? '';
      }
      return () {};
    }, []);

    return Expanded(
      child: Padding(
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
                    child: ModalCloseButton(),
                  ),
                ),
                Expanded(
                  child: ModalTitle(
                    label: 'Вес'.tr(),
                    textStyle: text_s17_w600_lsm043.copyWith(
                      color: palette.text,
                    ),
                  ),
                ),
                CheckButton(
                  onPress: isSubmitting.value
                      ? null
                      : () async {
                          isSubmitting.value = true;

                          try {
                            if (!isSameDouble(
                              state?.weight,
                              currentWeight.value,
                            )) {
                              final data = UpdateUser(
                                weight: currentWeight.value,
                              );
                              final newUser = await ref
                                  .read(userProvider.notifier)
                                  .updateUser(data);

                              if (newUser?.weight == null && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Что-то пошло не так'.tr()),
                                  ),
                                );
                                return;
                              }
                            }
                            if (context.mounted) {
                              context.router.pop();
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Что-то пошло не так'.tr()),
                                ),
                              );
                              return;
                            }
                          } finally {
                            if (context.mounted) {
                              isSubmitting.value = false;
                            }
                          }
                        },
                ),
              ],
            ),
            AppSpace.h32,
            ReactiveForm(
              formGroup: userNotifier.weightForm,
              child: AbsorbPointer(
                child: ReactiveInputField<String>(
                  fieldName: UserNotifier.weightFieldName,
                  labelText: 'Вес'.tr(),
                  hiddenErrors: ['required'],
                ),
              ),
            ),
            AppSpace.h16,
            Text(
              'Здесь вы можете изменить свой вес'.tr(),
              style: text_s14_w400_ls01.copyWith(color: palette.text60),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 150.h),
            SizedBox(
              height: 220.h,
              child: WeightRulerPicker(
                initialValue: currentWeight.value,
                onChanged: (value) => currentWeight.value = value,
              ),
            ),
            SizedBox(height: 120.h),
          ],
        ),
      ),
    );
  }
}
