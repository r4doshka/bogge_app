import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_border_radius.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StartWorkoutBanner extends ConsumerWidget {
  const StartWorkoutBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    return Stack(
      children: [
        PositionedDirectional(
          top: 0,
          end: 0,
          bottom: 0,
          start: 0,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/start-banner-image.png'),
                fit: BoxFit.fill,
              ),
              borderRadius: AppBorderRadius.all32,
              border: Border.all(width: 2, color: palette.white30),
            ),
          ),
        ),
        Row(
          children: [
            SizedBox(width: 14.w),
            SizedBox(
              width: 230.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 79.h),
                  Text(
                    'Время двигаться'.tr(),
                    style: text_s17_w700_lsm043.copyWith(
                      color: palette.primary,
                    ),
                    maxLines: 1,
                  ),
                  Text(
                    'Подключите дорожку и начните бег'.tr(),
                    style: text_s13_w400_lsm043.copyWith(color: palette.text),
                    maxLines: 1,
                  ),
                  AppSpace.h8,
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: AppSpace.s12.w),
                    child: PrimaryButton(
                      text: 'Начать тренировку'.tr(),
                      renderLeftIcon: () => Padding(
                        padding: EdgeInsetsDirectional.only(end: 5.5.w),
                        child: SvgPicture.asset(
                          'assets/icons/play-small-icon.svg',
                          width: AppSpace.s12.w,
                          height: 14.h,
                        ),
                      ),
                      onPress: () {},
                    ),
                  ),
                  SizedBox(height: 14.h),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
