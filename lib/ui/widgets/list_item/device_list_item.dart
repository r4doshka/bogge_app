import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/box_shadows.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeviceListItem extends ConsumerWidget {
  const DeviceListItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    return Padding(
      padding: EdgeInsetsDirectional.only(top: AppSpace.s4),
      child: Row(
        children: [
          Image.asset(
            'assets/images/treadmill-image.png',
            width: 49.w,
            height: 51.h,
          ),
          AppSpace.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Neorun PRO',
                  style: text_s17_w500_lsm043.copyWith(color: palette.text),
                ),
                Text(
                  'Беговая дорожка'.tr(),
                  style: text_s11_w400_lsm043.copyWith(color: palette.text60),
                ),
              ],
            ),
          ),
          // Text(
          //   'Не подключено'.tr(),
          //   style: text_s17_w400_lsm043.copyWith(color: palette.text60),
          // ),
          // PrimaryButton(
          //   text: 'Отключить'.tr(),
          //   backgroundColor: palette.cancelDark,
          //   textStyle: text_s14_w500_lsm043.copyWith(color: palette.white),
          //   padding: EdgeInsetsDirectional.symmetric(
          //     vertical: 7.h,
          //     horizontal: 14.w,
          //   ),
          //   onPress: () {},
          // ),
          Container(
            decoration: BoxDecoration(
              boxShadow: AppBoxShadows.buttonSmallBoxShadow,
            ),
            child: PrimaryButton(
              text: 'Подключить'.tr(),
              textStyle: text_s14_w500_lsm043.copyWith(color: palette.white),
              padding: EdgeInsetsDirectional.symmetric(
                vertical: 7.h,
                horizontal: 14.w,
              ),
              onPress: () {},
            ),
          ),
          // PrimaryButton(
          //   text: 'Подключение'.tr(),
          //   textStyle: text_s14_w500_lsm043.copyWith(color: palette.white),
          //   backgroundColor: palette.primaryDark,
          //   padding: EdgeInsetsDirectional.symmetric(
          //     vertical: 7.h,
          //     horizontal: 14.w,
          //   ),
          //   renderLeftIcon: () => Padding(
          //     padding: EdgeInsetsDirectional.only(end: AppSpace.s8),
          //     child: Spinner(width: 12.w, height: 12.h, strokeWidth: 2.w),
          //   ),
          //   onPress: () {},
          // ),
        ],
      ),
    );
  }
}
