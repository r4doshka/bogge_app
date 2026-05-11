import 'package:bogge_app/models/router/router_model.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/modals/widgets/default_modal_bottom.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/modals/widgets/modal_close_button.dart';
import 'package:bogge_app/ui/widgets/modals/widgets/modal_title.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> showEditUserNameModalBottom({
  required BuildContext context,
}) async {
  final mediaQuery = MediaQuery.of(context);
  return await showDefaultModalBottom(
    context: context,
    minHeight: mediaQuery.size.height * 0.94,
    hasCloseButton: false,
    modalName: AppModalList.editUserName.title,
    child: EditUserNameModal(),
  );
}

class EditUserNameModal extends ConsumerWidget {
  const EditUserNameModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);

    return Padding(
      padding: AppSpace.ph16,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: AppSpace.s48.w,
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
                  textStyle: text_s15_w600_lsm043.copyWith(color: palette.text),
                ),
              ),
              AppSpace.w48,
            ],
          ),
          AppSpace.h16,
        ],
      ),
    );
  }
}
