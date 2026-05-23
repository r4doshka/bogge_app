import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_border_radius.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/containers/highlight_container.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WorkoutListItem extends ConsumerWidget {
  final WorkoutStatType item;
  final String value;
  final void Function() onPress;

  const WorkoutListItem({
    required this.onPress,
    required this.item,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    return HighlightContainer(
      onPress: onPress,
      borderRadius: AppBorderRadius.all24,
      padding: EdgeInsetsDirectional.only(
        top: AppSpace.s12.h,
        bottom: AppSpace.s12.h,
        start: AppSpace.s16.w,
        end: AppSpace.s28.w,
      ),
      decoration: BoxDecoration(
        borderRadius: AppBorderRadius.all24,
        color: palette.white,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/man-on-treadmill-icon.svg',
            width: AppSpace.s24.spMin,
            height: AppSpace.s24.spMin,
            colorFilter: ColorFilter.mode(palette.primary, BlendMode.srcIn),
          ),
          AppSpace.w16,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Бег на дорожке'.tr(),
                style: text_s14_w400_lsm043.copyWith(color: palette.text),
              ),
              Text(
                'Вторник, 10 февраля',
                style: text_s11_w400_lsm043.copyWith(color: palette.text60),
              ),
            ],
          ),
          Spacer(),
          Text(
            '3,039 км',
            style: text_s17_w400_lsm043.copyWith(color: palette.primary),
          ),
          AppSpace.w16,
          SvgPicture.asset(
            'assets/icons/chevron-right-icon.svg',
            width: AppSpace.s16.w,
            height: AppSpace.s16.w,
            colorFilter: ColorFilter.mode(palette.text30, BlendMode.srcIn),
            matchTextDirection: true,
          ),
        ],
      ),
    );
  }
}
