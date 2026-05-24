import 'dart:async';
import 'dart:io';

import 'package:bogge_app/features/bluetooth/models/bluetooth_adapter_state.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:app_settings/app_settings.dart';

class BluetoothAdapterController extends Notifier<BluetoothAdapterStateModel> {
  StreamSubscription<BluetoothAdapterState>? _adapterSub;

  @override
  BluetoothAdapterStateModel build() {
    _adapterSub = FlutterBluePlus.adapterState.listen((adapterState) {
      state = state.copyWith(
        adapterState: adapterState,
        isOn: adapterState == BluetoothAdapterState.on,
      );
    });

    ref.onDispose(() {
      _adapterSub?.cancel();
    });

    return BluetoothAdapterStateModel.initial();
  }

  Future<bool> ensureBluetoothEnabled() async {
    final currentState = FlutterBluePlus.adapterStateNow;

    if (currentState == BluetoothAdapterState.on) {
      state = state.copyWith(adapterState: currentState, isOn: true);
      return false;
    }

    if (Platform.isAndroid) {
      try {
        await FlutterBluePlus.turnOn();

        final enabledState = await FlutterBluePlus.adapterState
            .where((s) => s == BluetoothAdapterState.on)
            .first;

        state = state.copyWith(adapterState: enabledState, isOn: true);
      } catch (_) {
        await AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
      }
    } else {
      await AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
    }

    return state.adapterState == BluetoothAdapterState.on;
  }

  Future<void> openBluetoothSettings() async {
    await AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
  }
}
