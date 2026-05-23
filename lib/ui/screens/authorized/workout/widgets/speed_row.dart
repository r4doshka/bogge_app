import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SpeedRow extends ConsumerWidget {
  const SpeedRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(top: 7.h),
          child: SvgPicture.asset(
            'assets/icons/speed-icon.svg',
            width: AppSpace.s44.spMin,
            height: AppSpace.s44.spMin,
          ),
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '0',
                  style: text_s48_w900_lsm043.copyWith(color: palette.text),
                ),
                AppSpace.w4,
                Text(
                  'Км/ч'.tr().toLowerCase(),
                  style: text_s48_w400_lsm043.copyWith(color: palette.text),
                ),
              ],
            ),
            Text(
              'Скорость'.tr(),
              style: text_s17_w400_lsm043.copyWith(color: palette.text60),
            ),
          ],
        ),
      ],
    );
  }
}
