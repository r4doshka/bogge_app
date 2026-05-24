import 'package:bogge_app/features/ftms/models/paired_ftms_devices.dart';
import 'package:bogge_app/features/ftms/providers/ftms_provider.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SavedDeviceListItem extends ConsumerWidget {
  final PairedFtmsDevice item;
  final void Function()? onDisconnect;

  const SavedDeviceListItem({required this.item, this.onDisconnect, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);
    final state = ref.watch(ftmsProvider);

    final isConnected =
        state.connectionStatus == ConnectionStatus.connected &&
        state.device?.remoteId.str == item.remoteId;

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
                  item.name,
                  style: text_s17_w500_lsm043.copyWith(color: palette.text),
                ),
                Text(
                  'Беговая дорожка'.tr(),
                  style: text_s11_w400_lsm043.copyWith(color: palette.text60),
                ),
              ],
            ),
          ),
          if (isConnected)
            PrimaryButton(
              text: 'Отключить'.tr(),
              backgroundColor: palette.cancelDark,
              textStyle: text_s14_w500_lsm043.copyWith(color: palette.white),
              padding: EdgeInsetsDirectional.symmetric(
                vertical: 7.h,
                horizontal: 14.w,
              ),
              onPress: onDisconnect,
            )
          else
            Text(
              'Не подключено'.tr(),
              style: text_s17_w400_lsm043.copyWith(color: palette.text60),
            ),
        ],
      ),
    );
  }
}
