import 'dart:async';
import 'package:bogge_app/features/bluetooth/providers/bluetooth_adapter_provider.dart';
import 'package:bogge_app/features/ftms/helpers/check_is_treadmill.dart';
import 'package:bogge_app/features/ftms/helpers/ftms_parser.dart';
import 'package:bogge_app/features/ftms/models/ftms_state.dart';
import 'package:bogge_app/features/ftms/models/ftms_uuids_model.dart';
import 'package:bogge_app/features/ftms/models/paired_ftms_devices.dart';
import 'package:bogge_app/providers/shared_preferences_provider.dart';
import 'package:bogge_app/ui/widgets/modals/device_scan_modal.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FtmsController extends Notifier<FtmsState> {
  BluetoothDevice? _device;

  BluetoothCharacteristic? _treadmillChar;
  BluetoothCharacteristic? _controlPointChar;

  StreamSubscription? _scanSub;
  StreamSubscription? _notifySub;
  StreamSubscription? _controlPointSub;

  final List<int> _buffer = [];

  static const _minProgressDuration = Duration(seconds: 2);
  static const _scanDuration = Duration(seconds: 10);

  List<ScanResult> _pendingDevices = [];

  bool _isSpeedChanging = false;

  @override
  FtmsState build() {
    final savedDevices = ref
        .read(sharedPreferencesServiceProvider)
        .getPairedFtmsDevices();

    ref.onDispose(_dispose);

    return FtmsState(savedDevices: savedDevices);
  }

  Future<void> startScan() async {
    try {
      final bluetoothState = ref.read(bluetoothAdapterProvider);

      if (!bluetoothState.isOn) {
        state = state.copyWith(
          scanStatus: ScanStatus.error,
          error: 'Bluetooth выключен',
        );
        return;
      }

      await FlutterBluePlus.stopScan();
      await _scanSub?.cancel();

      _pendingDevices = [];

      state = state.copyWith(
        scanStatus: ScanStatus.inProgress,
        devices: [],
        error: null,
      );

      final startedAt = DateTime.now();

      _scanSub = FlutterBluePlus.scanResults.listen((results) {
        _pendingDevices = results.where(checkIsTreadmill).toList();

        state = state.copyWith(devices: _pendingDevices);
      });

      // максимум 8 секунд
      await FlutterBluePlus.startScan(timeout: _scanDuration);

      final elapsed = DateTime.now().difference(startedAt);

      // минимум 2 секунды
      if (elapsed < _minProgressDuration) {
        await Future.delayed(_minProgressDuration - elapsed);
      }

      if (!ref.mounted) return;

      state = state.copyWith(
        scanStatus: _pendingDevices.isEmpty
            ? ScanStatus.empty
            : ScanStatus.success,
      );
    } catch (e) {
      state = state.copyWith(scanStatus: ScanStatus.error, error: e.toString());
    }
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
    await _scanSub?.cancel();

    state = state.copyWith(
      scanStatus: state.devices.isEmpty ? ScanStatus.empty : ScanStatus.success,
    );
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      if (_device != null && _device!.remoteId != device.remoteId) {
        await disconnect();
      }

      state = state.copyWith(
        connectionStatus: ConnectionStatus.connecting,
        connectingDeviceId: device.remoteId,
        error: null,
      );

      _device = device;

      await FlutterBluePlus.stopScan();
      await _scanSub?.cancel();

      await _device!.connect(autoConnect: false, license: License.free);

      final services = await _device!.discoverServices();

      _treadmillChar = null;
      _controlPointChar = null;

      for (final service in services) {
        if (service.uuid == FtmsUuids.service) {
          for (final char in service.characteristics) {
            if (char.uuid == FtmsUuids.treadmillData) {
              _treadmillChar = char;
            }

            if (char.uuid == FtmsUuids.controlPoint) {
              _controlPointChar = char;
            }
          }
        }
      }

      if (_treadmillChar == null) {
        throw Exception('Treadmill Data characteristic not found');
      }

      await _treadmillChar!.setNotifyValue(true);

      await _notifySub?.cancel();

      _notifySub = _treadmillChar!.lastValueStream.listen(_handleIncoming);

      final connectedDevice = PairedFtmsDevice(
        remoteId: device.remoteId.str,
        name: device.platformName.isNotEmpty
            ? device.platformName
            : 'Беговая дорожка',
      );

      await ref
          .read(sharedPreferencesServiceProvider)
          .addPairedFtmsDevice(connectedDevice);

      final savedDevices = ref
          .read(sharedPreferencesServiceProvider)
          .getPairedFtmsDevices();

      state = state.copyWith(
        connectionStatus: ConnectionStatus.connected,
        device: device,
        savedDevices: savedDevices,
        clearConnectingDeviceId: true,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        connectionStatus: ConnectionStatus.error,
        connectingDeviceId: null,
        clearConnectingDeviceId: true,
        error: e.toString(),
      );
    }
  }

  Future<void> disconnect() async {
    state = state.copyWith(connectionStatus: ConnectionStatus.disconnecting);

    await _notifySub?.cancel();
    await _controlPointSub?.cancel();

    await _device?.disconnect();

    _device = null;
    _treadmillChar = null;
    _controlPointChar = null;
    _buffer.clear();

    state = state.copyWith(
      connectionStatus: ConnectionStatus.disconnected,
      device: null,
      lastRawData: null,
      clearWorkoutData: true,
      clearConnectingDeviceId: true,
      treadmillStatus: TreadmillStatus.idle,
    );
  }

  void _handleIncoming(List<int> data) {
    if (data.length < 2) return;

    final flags = data[0] | (data[1] << 8);
    final isMoreDataPacket = (flags & 0x0001) != 0;

    final workoutData = parseFtms(data);

    // print('rawData $data');
    // print('workoutData $workoutData');

    if (isMoreDataPacket) {
      state = state.copyWith(lastRawData: data);
      return;
    }

    state = state.copyWith(lastRawData: data, workoutData: workoutData);
  }

  void _dispose() {
    _scanSub?.cancel();
    _notifySub?.cancel();
    _controlPointSub?.cancel();
    _device?.disconnect();
  }

  Future<void> resetScan() async {
    await FlutterBluePlus.stopScan();
    await _scanSub?.cancel();

    _pendingDevices = [];

    state = state.copyWith(
      scanStatus: ScanStatus.initial,
      devices: [],
      error: null,
      clearConnectingDeviceId: true,
    );
  }

  Future<void> restartScan() async {
    await resetScan();
    await startScan();
  }

  Future<void> startDeviceFlow(BuildContext context) async {
    if (state.connectionStatus == ConnectionStatus.connecting) {
      return;
    }

    if (!ref.read(bluetoothAdapterProvider).isOn) {
      await ref
          .read(bluetoothAdapterProvider.notifier)
          .ensureBluetoothEnabled();

      if (!ref.read(bluetoothAdapterProvider).isOn) {
        return;
      }
    }

    if (context.mounted) {
      showDeviceScanModalBottom(context: context);

      await startScan();
    }
  }

  Future<void> startTreadmill() async {
    try {
      if (_controlPointChar == null) {
        throw Exception('Control Point characteristic not found');
      }

      if (state.connectionStatus != ConnectionStatus.connected) {
        throw Exception('Device is not connected');
      }

      /// request control
      await _controlPointChar!.write([0x00], withoutResponse: false);

      await Future.delayed(const Duration(milliseconds: 300));

      /// start/resume
      await _controlPointChar!.write([0x07], withoutResponse: false);
      state = state.copyWith(treadmillStatus: TreadmillStatus.running);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> stopTreadmill() async {
    try {
      if (_controlPointChar == null) {
        throw Exception('Control Point characteristic not found');
      }

      if (state.connectionStatus != ConnectionStatus.connected) {
        throw Exception('Device is not connected');
      }

      /// FTMS Stop/Pause opcode
      /// 0x08 = Stop/Pause
      /// 0x01 = Stop
      await _controlPointChar!.write([0x08, 0x01], withoutResponse: false);
      state = state.copyWith(treadmillStatus: TreadmillStatus.stopped);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> pauseTreadmill() async {
    try {
      if (_controlPointChar == null) {
        throw Exception('Control Point characteristic not found');
      }

      if (state.connectionStatus != ConnectionStatus.connected) {
        throw Exception('Device is not connected');
      }

      /// FTMS Stop/Pause opcode
      /// 0x08 = Stop/Pause
      /// 0x02 = Pause
      await _controlPointChar!.write([0x08, 0x02], withoutResponse: false);
      state = state.copyWith(treadmillStatus: TreadmillStatus.paused);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> increaseSpeed({double step = 0.1}) async {
    final currentSpeed = state.targetSpeed ?? state.workoutData?.speed ?? 0;

    await setSpeed(currentSpeed + step);
  }

  Future<void> decreaseSpeed({double step = 0.1}) async {
    final currentSpeed = state.targetSpeed ?? state.workoutData?.speed ?? 0;

    await setSpeed(currentSpeed - step);
  }

  Future<void> setSpeed(double speed) async {
    if (_isSpeedChanging) return;

    _isSpeedChanging = true;

    final normalizedSpeed = speed.clamp(0.1, 20.0).toDouble();

    state = state.copyWith(targetSpeed: normalizedSpeed);

    try {
      if (_controlPointChar == null) {
        throw Exception('Control Point characteristic not found');
      }

      if (state.connectionStatus != ConnectionStatus.connected) {
        throw Exception('Device is not connected');
      }

      final speedValue = (normalizedSpeed * 100).round();

      await _controlPointChar!.write([
        0x02,
        speedValue & 0xFF,
        (speedValue >> 8) & 0xFF,
      ], withoutResponse: false);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      _isSpeedChanging = false;
    }
  }

  void saveLastWorkoutData() {
    final data = state.workoutData;

    if (data == null) return;

    state = state.copyWith(lastWorkoutData: data);
  }
}
