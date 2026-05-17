import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/user/models/update_user.dart';
import 'package:bogge_app/features/user/providers/user_provider.dart';
import 'package:bogge_app/models/router/router_model.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/check_button.dart';
import 'package:bogge_app/ui/widgets/form/group_radio_buttons.dart';
import 'package:bogge_app/ui/widgets/modals/widgets/default_modal_bottom.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/modals/widgets/modal_close_button.dart';
import 'package:bogge_app/ui/widgets/modals/widgets/modal_title.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> showEditGenderModalBottom({required BuildContext context}) async {
  final mediaQuery = MediaQuery.of(context);
  return await showDefaultModalBottom(
    context: context,
    minHeight: mediaQuery.size.height * 0.94,
    hasCloseButton: false,
    modalName: AppModalList.editGender.title,
    child: EditGenderModal(),
  );
}

class EditGenderModal extends HookConsumerWidget {
  const EditGenderModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);
    final state = ref.watch(userProvider);
    final sexType = useState<SexType?>(state?.sex);
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
                  child: ModalCloseButton(),
                ),
              ),
              Expanded(
                child: ModalTitle(
                  label: 'Пол'.tr(),
                  textStyle: text_s17_w600_lsm043.copyWith(color: palette.text),
                ),
              ),
              CheckButton(
                onPress: sexType.value == null || isSubmitting.value
                    ? null
                    : () async {
                        isSubmitting.value = true;

                        try {
                          if (sexType.value != state?.sex) {
                            final data = UpdateUser(sex: sexType.value);
                            final newUser = await ref
                                .read(userProvider.notifier)
                                .updateUser(data);

                            if (newUser?.sex == null && context.mounted) {
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
          RadioButtonsGroup<SexType>(
            options: SexType.options,
            selectedValue: sexType.value,
            onChange: (val) => sexType.value = val,
          ),
          AppSpace.h16,
          Text(
            'Здесь вы можете изменить пол профиля'.tr(),
            style: text_s14_w400_ls01.copyWith(color: palette.text60),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
