import 'package:bogge_app/models/router/router_model.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_border_radius.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/modals/widgets/default_modal_bottom.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> showUserAgreementModalBottom({
  required BuildContext context,
}) async {
  return await showDefaultModalBottom(
    context: context,
    title: 'Пользовательское соглашение'.tr(),
    modalName: AppModalList.userAgreement.title,
    child: UserAgreementModal(),
  );
}

class UserAgreementModal extends ConsumerWidget {
  const UserAgreementModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);

    return Padding(
      padding: AppSpace.ph16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 26.h),
          Text(
            'Настоящая Политика конфиденциальности описывает какие данные мы собираем как их используем и какие права есть у пользователей при использовании нашего приложения'
                .tr(),
            style: text_s14_w400_lsm043.copyWith(color: palette.text),
          ),
          AppSpace.h8,
          Text(
            'Используя приложение вы соглашаетесь с условиями данной Политики конфиденциальности'
                .tr(),
            style: text_s14_w400_lsm043.copyWith(color: palette.text),
          ),
          AppSpace.h16,
          Text(
            '1 Общие положения'.tr(),
            style: text_s14_w700_lsm043.copyWith(color: palette.text),
          ),
          AppSpace.h8,
          Text(
            'Мы уважаем право пользователей на конфиденциальность и стремимся защищать персональные данные в соответствии с применимым законодательством Обработка данных осуществляется добросовестно законно и только в объёме необходимом для работы сервиса'
                .tr(),
            style: text_s14_w400_lsm043.copyWith(color: palette.text),
          ),
          AppSpace.h16,
          Text(
            '2 Какие данные мы собираем',
            style: text_s14_w700_lsm043.copyWith(color: palette.text),
          ),
          AppSpace.h8,
          Text(
            'В зависимости от способа использования приложения мы можем собирать следующие категории данных'
                .tr(),
            style: text_s14_w400_lsm043.copyWith(color: palette.text),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Dot(),
              AppSpace.w4,
              Text('контактные данные (например, email)'.tr()),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Dot(),
              AppSpace.w4,
              Text('данные аккаунта и авторизации'.tr()),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Dot(),
              AppSpace.w4,
              Expanded(
                child: Text(
                  'технические данные устройства (тип устройства, версия ОС, идентификаторы)'
                      .tr(),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Dot(),
              AppSpace.w4,
              Text('данные об использовании приложения'.tr()),
            ],
          ),
        ],
      ),
    );
  }
}

class _Dot extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);
    return Container(
      margin: EdgeInsetsDirectional.only(top: AppSpace.s8.h),
      width: 3.w,
      height: 3.w,
      decoration: BoxDecoration(
        color: palette.text,
        borderRadius: AppBorderRadius.all12,
      ),
    );
  }
}
