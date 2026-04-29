import 'package:bogge_app/models/router/router_model.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/services/navigation_service.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_text_button.dart';
import 'package:bogge_app/ui/widgets/modals/widgets/default_modal_bottom.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> showEmptyProfileModalBottom({
  required BuildContext context,
}) async {
  final mediaQuery = MediaQuery.of(context);
  return await showDefaultModalBottom(
    context: context,
    title: 'Профиль'.tr(),
    minHeight: mediaQuery.size.height * 0.94,
    modalName: AppModalList.emptyProfile.title,
    child: EmptyProfileModal(),
  );
}

class EmptyProfileModal extends ConsumerWidget {
  const EmptyProfileModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);
    final navigationService = ref.read(navigationServiceProvider);

    return Padding(
      padding: AppSpace.ph16,
      child: Column(
        children: [
          SizedBox(height: 92.h),
          SvgPicture.asset('assets/icons/man-icon.svg'),
          AppSpace.h32,
          Text(
            'Гостевой режим'.tr(),
            style: text_s25_w700_ls04.copyWith(color: palette.text),
            textAlign: TextAlign.center,
          ),
          AppSpace.h16,
          Text(
            'Создайте аккаунт или войдите чтобы мы могли сохранять ваши тренировки и статистику на всех устройствах'
                .tr(),
            style: text_s14_w400_ls01.copyWith(color: palette.text60),
            textAlign: TextAlign.center,
          ),
          AppSpace.h16,
          PrimaryButton(
            text: 'Зарегистрироваться'.tr(),
            onPress: () => navigationService.goToSignUp(context),
          ),
          AppSpace.h16,
          PrimaryTextButton(
            text: 'Уже есть аккаунт? Войти'.tr(),
            onPress: () => navigationService.goToSignIn(context),
          ),
        ],
      ),
    );
  }
}
