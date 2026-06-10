import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/containers/highlight_container.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StatisticListItem extends ConsumerWidget {
  final WorkoutStatsType item;
  final String value;
  final BorderRadius? borderRadius;
  final void Function()? onPress;
  final bool isLast;

  const StatisticListItem({
    required this.item,
    required this.value,
    this.onPress,
    this.borderRadius,
    this.isLast = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    return HighlightContainer(
      onPress: onPress,
      borderRadius: borderRadius,
      padding: EdgeInsetsDirectional.symmetric(horizontal: AppSpace.s16.w),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: palette.white,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            item.iconPath,
            width: AppSpace.s24.spMin,
            height: AppSpace.s24.spMin,
            colorFilter: ColorFilter.mode(palette.primary, BlendMode.srcIn),
          ),
          AppSpace.w16,
          Expanded(
            child: Container(
              padding: AppSpace.pv12,
              decoration: BoxDecoration(
                border: Border(
                  bottom: isLast
                      ? BorderSide.none
                      : BorderSide(color: palette.gray),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    item.title.tr(),
                    style: text_s17_w400_lsm043.copyWith(color: palette.text),
                  ),
                  AppSpace.w20,
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            value,
                            style: text_s17_w400_lsm043.copyWith(
                              color: palette.primary,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSpace.w16,
                  if (onPress != null)
                    SvgPicture.asset(
                      'assets/icons/chevron-right-icon.svg',
                      width: AppSpace.s16.w,
                      height: AppSpace.s16.w,
                      colorFilter: ColorFilter.mode(
                        palette.text30,
                        BlendMode.srcIn,
                      ),
                      matchTextDirection: true,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
