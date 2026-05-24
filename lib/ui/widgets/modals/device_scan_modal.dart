import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/ftms/providers/ftms_provider.dart';
import 'package:bogge_app/models/router/router_model.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/box_shadows.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/animations/bluetooth_pulse.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_icon_button.dart';
import 'package:bogge_app/ui/widgets/lists/device_list.dart';
import 'package:bogge_app/ui/widgets/modals/widgets/default_modal_bottom.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/widgets/modals/widgets/modal_title.dart';
import 'package:bogge_app/ui/widgets/scan_error_list.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> showDeviceScanModalBottom({required BuildContext context}) async {
  return await showDefaultModalBottom(
    context: context,
    hasCloseButton: false,
    shrinkWrap: true,
    modalName: AppModalList.deviceScan.title,
    child: DeviceScanModal(),
  );
}

class DeviceScanModal extends HookConsumerWidget {
  const DeviceScanModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(paletteProvider);
    final state = ref.watch(ftmsProvider);

    final status = ref.watch(ftmsProvider.select((state) => state.scanStatus));
    final isBusy = state.connectionStatus == ConnectionStatus.connecting;

    return Padding(
      padding: AppSpace.ph16,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            if (status != ScanStatus.error && status != ScanStatus.empty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppSpace.w44,
                  Column(
                    children: [
                      ModalTitle(label: 'Сканирование'.tr()),
                      Text(
                        'Поиск доступного устройства'.tr(),
                        style: text_s12_w400_ls01.copyWith(
                          color: palette.text60,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  if (status == ScanStatus.inProgress)
                    AppSpace.w44
                  else
                    PrimaryIconButton(
                      svgPath: 'assets/icons/arrow-repeat-icon.svg',
                      iconWidth: AppSpace.s28.w,
                      iconHeight: AppSpace.s28.h,
                      containerHeight: AppSpace.s44.w,
                      containerWidth: AppSpace.s44.w,
                      backgroundColor: palette.primary12,
                      onPress: () => status == ScanStatus.inProgress
                          ? null
                          : ref.read(ftmsProvider.notifier).restartScan(),
                    ),
                ],
              ),
            ],
            if (status == ScanStatus.inProgress) ...[
              SizedBox(height: 76.h),
              BluetoothPulse(),
              AppSpace.h44,
            ],

            if (state.devices.isNotEmpty &&
                status != ScanStatus.inProgress) ...[
              AppSpace.h32,
              if (state.devices.isNotEmpty)
                DeviceList(
                  list: state.devices,
                  onConnect: isBusy
                      ? null
                      : (device) async {
                          await ref
                              .read(ftmsProvider.notifier)
                              .connectToDevice(device);

                          final connectionStatus = ref.read(
                            ftmsProvider.select((s) => s.connectionStatus),
                          );

                          if (connectionStatus == ConnectionStatus.connected &&
                              context.mounted) {
                            context.router.pop();
                          }
                        },
                ),
            ],

            if (status == ScanStatus.error || status == ScanStatus.empty) ...[
              AppSpace.h4,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ModalTitle(label: 'Ошибка сканирования'.tr())],
              ),
              Text(
                'Невозможно найти устройство'.tr(),
                style: text_s12_w400_ls01.copyWith(color: palette.text60),
                textAlign: TextAlign.center,
              ),
              AppSpace.h32,
              Padding(padding: AppSpace.ph8, child: ScanErrorList()),
              SizedBox(height: 60.h),
              Padding(
                padding: AppSpace.ph16,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: AppBoxShadows.buttonBoxShadow,
                  ),
                  child: PrimaryButton(
                    text: 'Повторное сканирование'.tr(),
                    onPress: () =>
                        ref.read(ftmsProvider.notifier).restartScan(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
