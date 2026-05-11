import 'package:bogge_app/models/settings_section_model.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/containers/highlight_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:bogge_app/ui/ui_tokens/app_border_radius.dart';

class SettingsItem extends ConsumerWidget {
  final SettingsSectionModel item;

  const SettingsItem({required this.item, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (SettingsSectionChildModel child in item.children)
          HighlightContainer(
            onPress: child.onPress,
            borderRadius: getBorderRadius(child),
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: AppSpace.s16.w,
            ),
            decoration: BoxDecoration(
              borderRadius: getBorderRadius(child),
              color: palette.white,
            ),
            child: Row(
              children: [
                if (child.iconPath != null) ...[
                  SvgPicture.asset(
                    child.iconPath!,
                    width: AppSpace.s24.w,
                    height: AppSpace.s24.w,
                    colorFilter: ColorFilter.mode(
                      palette.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  AppSpace.w16,
                ],
                Expanded(
                  child: Container(
                    padding: AppSpace.pv12,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: !getIsLastItem(child)
                            ? BorderSide(color: palette.gray)
                            : BorderSide.none,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          child.title,
                          style: text_s17_w400_lsm043.copyWith(
                            color: palette.text,
                          ),
                        ),
                        AppSpace.w20,
                        if (child.rightPartRenderer != null) ...[
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(child: child.rightPartRenderer!()),
                              ],
                            ),
                          ),
                        ] else
                          Spacer(),
                        if (child.withArrowRight) ...[
                          AppSpace.w16,
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  bool getIsLastItem(SettingsSectionChildModel child) {
    final index = item.children.indexOf(child);
    return index == item.children.length - 1;
  }

  bool getIsFirstItem(SettingsSectionChildModel child) {
    final index = item.children.indexOf(child);
    return index == 0;
  }

  BorderRadius getBorderRadius(SettingsSectionChildModel child) {
    final isLastItem = getIsLastItem(child);
    final isFirstItem = getIsFirstItem(child);

    if (isLastItem && isFirstItem) {
      return const BorderRadius.only(
        topLeft: AppBorderRadius.r24,
        topRight: AppBorderRadius.r24,
        bottomLeft: AppBorderRadius.r24,
        bottomRight: AppBorderRadius.r24,
      );
    }

    if (isFirstItem) {
      return const BorderRadius.only(
        topLeft: AppBorderRadius.r24,
        topRight: AppBorderRadius.r24,
        bottomLeft: Radius.zero,
        bottomRight: Radius.zero,
      );
    }

    if (isLastItem) {
      return const BorderRadius.only(
        topLeft: Radius.zero,
        topRight: Radius.zero,
        bottomLeft: AppBorderRadius.r24,
        bottomRight: AppBorderRadius.r24,
      );
    }

    return BorderRadius.zero;
  }
}
