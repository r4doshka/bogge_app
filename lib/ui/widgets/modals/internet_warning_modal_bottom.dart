import 'package:bogge_app/models/router/router_model.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/modals/widgets/default_modal_bottom.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> showInternetWarningModalBottom({
  required BuildContext context,
}) async {
  return await showDefaultModalBottom(
    context: context,
    isDismissible: false,
    hasCloseButton: false,
    modalName: AppModalList.internetWarning.title,
    child: InternetWarning(),
  );
}

class InternetWarning extends ConsumerWidget {
  const InternetWarning({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);

    return Padding(
      padding: AppSpace.ph16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSpace.h20,
          SvgPicture.asset(
            'assets/icons/no_internet.svg',
            width: AppSpace.s32.w,
            height: AppSpace.s32.w,
            matchTextDirection: true,
          ),
          AppSpace.h8,
          Text(
            'Нет соединения с интернетом'.tr(),
            style: text_s25_w700_ls04.copyWith(color: palette.white),
          ),
          AppSpace.h16,
          Text(
            "Не удаётся загрузить страницу из-за нестабильного соединения Проверьте ваше интернет-соединение"
                .tr(),
            style: text_s14_w400_lsm043.copyWith(color: palette.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
