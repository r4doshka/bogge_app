import 'package:auto_route/auto_route.dart';
import 'package:bogge_app/features/ftms/providers/ftms_provider.dart';
import 'package:bogge_app/features/bluetooth/providers/bluetooth_adapter_provider.dart';
import 'package:bogge_app/providers/theme/palette_provider.dart';
import 'package:bogge_app/ui/ui_tokens/app_space.dart';
import 'package:bogge_app/ui/ui_tokens/typographic.dart';
import 'package:bogge_app/ui/widgets/buttons/primary_button.dart';
import 'package:bogge_app/ui/widgets/headers/nested_header.dart';
import 'package:bogge_app/ui/widgets/lists/saved_device_list.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class DevicesScreen extends HookConsumerWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.read(paletteProvider);

    final state = ref.watch(ftmsProvider);
    final savedDevices = ref.watch(
      ftmsProvider.select((state) => state.savedDevices),
    );

    final ftmsController = ref.read(ftmsProvider.notifier);
    final bluetoothState = ref.watch(bluetoothAdapterProvider);

    final isActive = state.connectionStatus == ConnectionStatus.connected;

    useEffect(() {
      if (!bluetoothState.isOn && !isActive) {
        ref.read(bluetoothAdapterProvider.notifier).ensureBluetoothEnabled();
      }

      return null;
    }, []);

    useEffect(() {
      if (bluetoothState.isOn && !isActive) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          ref.read(ftmsProvider.notifier).startDeviceFlow(context);
        });
      }
      return () {
        ftmsController.resetScan();
      };
    }, [bluetoothState.isOn]);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpace.ph16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NestedHeader(title: 'Мои устройства'.tr()),
              AppSpace.h24,
              if (state.devices.isEmpty && state.savedDevices.isEmpty) ...[
                SizedBox(height: 108.h),
                Center(
                  child: SvgPicture.asset(
                    'assets/icons/device-connect-icon.svg',
                  ),
                ),
                AppSpace.h32,
                Padding(
                  padding: AppSpace.ph36,
                  child: Text(
                    'Чтобы начать, установите сопряжение с устройством'.tr(),
                    style: text_s17_w500_lsm043.copyWith(color: palette.text60),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              if (savedDevices.isNotEmpty &&
                  state.connectionStatus != ConnectionStatus.connecting)
                SavedDeviceList(
                  list: savedDevices,
                  onDisconnect: () =>
                      ref.read(ftmsProvider.notifier).disconnect(),
                ),
              Spacer(),
              PrimaryButton(
                text: 'Добавить новое устройство'.tr(),
                onPress: () =>
                    ref.read(ftmsProvider.notifier).startDeviceFlow(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
