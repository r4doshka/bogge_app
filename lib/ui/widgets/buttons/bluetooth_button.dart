import 'package:bogge_app/features/bluetooth/providers/ftms_provider.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_border_radius.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/containers/highlight_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BluetoothButton extends ConsumerWidget {
  const BluetoothButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    final state = ref.watch(ftmsProvider);

    // if (state.isConnected) {
    //   print("connected");
    // }

    // if (state.isConnecting) {
    //   print("isConnecting");
    // }

    // if (state.lastRawData != null) {
    //   print('========> ${state.lastRawData}');
    // }

    return HighlightContainer(
      borderRadius: AppBorderRadius.all24,
      padding: EdgeInsetsDirectional.symmetric(
        vertical: 11.h,
        horizontal: AppSpace.s16,
      ),
      decoration: BoxDecoration(
        color: palette.primary12,
        borderRadius: AppBorderRadius.all24,
      ),
      onPress: () async {
        if (state.isConnected) {
          ref.read(ftmsProvider.notifier).disconnect();
          return;
        }
        ref.read(ftmsProvider.notifier).connect();
      },
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/bluetooth-icon.svg',
            width: AppSpace.s20.w,
            height: AppSpace.s20.h,
          ),
          AppSpace.w8,
          Text(
            state.isConnected ? 'Neorun PRO' : 'Подключить'.tr(),
            style: text_s14_w500_lsm043.copyWith(color: palette.text),
          ),
        ],
      ),
    );
  }
}
