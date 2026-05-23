import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/providers/navigation/routers/authorized/authorized_router.gr.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_border_radius.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_icon_button.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_text_button.dart';
import 'package:bogge_app/ui/widgets/form/custom_swipe_switch.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WorkoutControlPanel extends HookConsumerWidget {
  final EdgeInsetsDirectional? padding;

  const WorkoutControlPanel({this.padding, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    final isBlocked = useState(false);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(38),
          topRight: Radius.circular(38),
        ),
        color: palette.white,
      ),
      child: Padding(
        padding: AppSpace.ph16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                height: 5.h,
                width: AppSpace.s36.w,
                margin: EdgeInsetsDirectional.only(top: 5.h),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  color: palette.text30,
                ),
              ),
            ),
            AppSpace.h16,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/timer-icon.svg',
                  width: AppSpace.s44.spMin,
                  height: AppSpace.s44.spMin,
                ),
                AppSpace.w16,
                Text(
                  '00:00,00',
                  style: text_s48_w900_lsm043.copyWith(color: palette.primary),
                ),
              ],
            ),
            AppSpace.h20,
            if (isBlocked.value)
              CustomSwipeSwitch(
                value: isBlocked.value,
                onChange: (val) => isBlocked.value = val,
              ),
            if (!isBlocked.value)
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 7.h),
                          PrimaryIconButton(
                            svgPath: 'assets/icons/cross1-icon.svg',
                            iconWidth: AppSpace.s44.spMin,
                            iconHeight: AppSpace.s44.spMin,
                            containerHeight: 84.spMin,
                            containerWidth: 84.spMin,
                            backgroundColor: palette.primary12,
                            onPress: () {},
                          ),
                          AppSpace.h4,
                          Text(
                            'Завершить'.tr(),
                            style: text_s14_w400_ls01.copyWith(
                              color: palette.text30,
                            ),
                          ),
                        ],
                      ),
                      PrimaryIconButton(
                        svgPath: 'assets/icons/play-icon.svg',
                        iconWidth: AppSpace.s44.spMin,
                        iconHeight: AppSpace.s44.spMin,
                        containerHeight: 122.spMin,
                        containerWidth: 122.spMin,
                        backgroundColor: palette.primary60,
                        onPress: () =>
                            context.router.replace(WorkoutFinishRoute()),
                      ),
                      Column(
                        children: [
                          SizedBox(height: 7.h),
                          PrimaryIconButton(
                            svgPath: 'assets/icons/lock-icon.svg',
                            iconWidth: AppSpace.s44.spMin,
                            iconHeight: AppSpace.s44.spMin,
                            containerHeight: 84.spMin,
                            containerWidth: 84.spMin,
                            backgroundColor: palette.primary12,
                            onPress: () => isBlocked.value = true,
                          ),
                          AppSpace.h4,
                          Text(
                            'Блокировка'.tr(),
                            style: text_s14_w400_ls01.copyWith(
                              color: palette.text30,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  AppSpace.h32,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PrimaryIconButton(
                        svgPath: 'assets/icons/minus-icon.svg',
                        iconWidth: 18.spMin,
                        iconHeight: 18.spMin,
                        containerHeight: AppSpace.s44.spMin,
                        containerWidth: 100.spMin,
                        backgroundColor: palette.primary12,
                        onPress: () {},
                      ),
                      Column(
                        children: [
                          Text(
                            '1',
                            style: text_s48_w900_lsm043.copyWith(
                              color: palette.primary,
                            ),
                          ),
                          AppSpace.h4,
                          Text(
                            'Км/ч'.tr(),
                            style: text_s14_w400_ls01.copyWith(
                              color: palette.text30,
                            ),
                          ),
                        ],
                      ),
                      PrimaryIconButton(
                        svgPath: 'assets/icons/plus-icon.svg',
                        iconWidth: 18.spMin,
                        iconHeight: 18.spMin,
                        containerHeight: AppSpace.s44.spMin,
                        containerWidth: 100.spMin,
                        backgroundColor: palette.primary12,
                        onPress: () {},
                      ),
                    ],
                  ),
                  AppSpace.h16,
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryTextButton(
                          text: '4',
                          height: AppSpace.s44.spMin,
                          backgroundColor: palette.primary12,
                          textStyle: text_s14_w700_lsm043.copyWith(
                            color: palette.text,
                          ),
                          textAlign: TextAlign.center,
                          borderRadius: AppBorderRadius.all100,
                          padding: EdgeInsetsDirectional.symmetric(
                            vertical: AppSpace.s8.h,
                            horizontal: AppSpace.s8.w,
                          ),
                          onPress: () {},
                        ),
                      ),
                      AppSpace.w20,
                      Expanded(
                        child: PrimaryTextButton(
                          text: '7',
                          height: AppSpace.s44.spMin,
                          backgroundColor: palette.primary12,
                          textStyle: text_s14_w700_lsm043.copyWith(
                            color: palette.text,
                          ),
                          textAlign: TextAlign.center,
                          borderRadius: AppBorderRadius.all100,
                          padding: EdgeInsetsDirectional.symmetric(
                            vertical: AppSpace.s8.h,
                            horizontal: AppSpace.s8.w,
                          ),
                          onPress: () {},
                        ),
                      ),
                      AppSpace.w20,
                      Expanded(
                        child: PrimaryTextButton(
                          text: '10',
                          height: AppSpace.s44.spMin,
                          backgroundColor: palette.primary12,
                          textStyle: text_s14_w700_lsm043.copyWith(
                            color: palette.text,
                          ),
                          textAlign: TextAlign.center,
                          borderRadius: AppBorderRadius.all100,
                          padding: EdgeInsetsDirectional.symmetric(
                            vertical: AppSpace.s8.h,
                            horizontal: AppSpace.s8.w,
                          ),
                          onPress: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            AppSpace.h12,
          ],
        ),
      ),
    );
  }
}
