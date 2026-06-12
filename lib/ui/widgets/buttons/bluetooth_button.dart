import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/ftms/providers/ftms_provider.dart';
import 'package:bogge_app/providers/navigation/routers/authorized/authorized_router.gr.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_border_radius.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/containers/highlight_container.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BluetoothButton extends ConsumerWidget {
  final VoidCallback? onPress;
  const BluetoothButton({this.onPress, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);
    final state = ref.watch(ftmsProvider);

    final isActive = state.connectionStatus == ConnectionStatus.connected;

    return HighlightContainer(
      borderRadius: AppBorderRadius.all24,
      padding: EdgeInsetsDirectional.symmetric(
        vertical: 11.h,
        horizontal: AppSpace.s16,
      ),
      decoration: BoxDecoration(
        color: isActive ? palette.primary : palette.primary12,
        borderRadius: AppBorderRadius.all24,
        border: Border.all(
          width: 2.h,
          color: isActive ? palette.white30 : Colors.transparent,
        ),
      ),
      onPress: onPress ?? () => context.router.push(DevicesRoute()),

      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/bluetooth-icon.svg',
            width: AppSpace.s20.w,
            height: AppSpace.s20.h,
            colorFilter: ColorFilter.mode(
              isActive ? palette.white : palette.text,
              BlendMode.srcIn,
            ),
          ),
          AppSpace.w8,
          Text(
            state.connectionStatus == ConnectionStatus.connected
                ? (state.device?.advName ?? 'Bogge')
                : 'Подключить'.tr(),
            style: text_s14_w500_lsm043.copyWith(
              color: isActive ? palette.white : palette.text,
            ),
          ),
        ],
      ),
    );
  }
}
