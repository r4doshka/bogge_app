import 'dart:async';

import 'package:bogge_app/features/bluetooth/helpers/ftms_parser.dart';
import 'package:bogge_app/features/bluetooth/models/ftms_data.dart';
import 'package:bogge_app/features/bluetooth/models/ftms_state.dart';
import 'package:bogge_app/features/bluetooth/models/ftms_uuids_model.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FtmsController extends Notifier<FtmsState> {
  BluetoothDevice? _device;

  BluetoothCharacteristic? _treadmillChar;
  BluetoothCharacteristic? _controlPointChar;

  StreamSubscription? _scanSub;
  StreamSubscription? _notifySub;

  StreamSubscription? _controlPointSub;

  bool _hasControlPermission = false;
  Completer<FtmsControlResponse>? _controlCompleter;

  /// 🔥 ВОТ ЭТО ТЫ СПРАШИВАЛ — БУФЕР
  final List<int> _buffer = [];

  @override
  FtmsState build() {
    ref.onDispose(_dispose);
    return const FtmsState();
  }

  // =========================
  // CONNECT
  // =========================
  Future<void> connect() async {
    try {
      state = state.copyWith(isConnecting: true, error: null);

      final completer = Completer<BluetoothDevice>();

      FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

      _scanSub?.cancel();
      _scanSub = FlutterBluePlus.scanResults.listen((results) {
        for (final r in results) {
          if (_hasFtmsService(r)) {
            if (!completer.isCompleted) {
              completer.complete(r.device);
            }
            break;
          }
        }
      });

      _device = await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception("FTMS device not found"),
      );

      await FlutterBluePlus.stopScan();
      await _scanSub?.cancel();

      await _device!.connect(autoConnect: false, license: License.free);

      final services = await _device!.discoverServices();

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
        throw Exception("Treadmill Data characteristic not found");
      }

      final enabled = await _treadmillChar!.setNotifyValue(true);
      if (!enabled) {
        final cccd = _controlPointChar!.descriptors.firstWhere(
          (d) => d.uuid.str.toLowerCase() == "2902",
        );

        await cccd.write([0x02, 0x00]);
      }

      _notifySub?.cancel();
      _notifySub = _treadmillChar!.value.listen(_handleIncoming);

      state = state.copyWith(
        isConnected: true,
        isConnecting: false,
        device: _device,
      );

      if (_controlPointChar != null) {
        print('CONTROL CHAR FOUND');

        await _controlPointChar!.setNotifyValue(true);

        _controlPointSub?.cancel();
        _controlPointSub = _controlPointChar!.value.listen((data) {
          print('CONTROL RESPONSE RAW: $data');
          _handleControlPoint(data);
        });
      }
    } catch (e) {
      state = state.copyWith(isConnecting: false, error: e.toString());
    }
  }

  // =========================
  // DISCONNECT
  // =========================
  Future<void> disconnect() async {
    await _device?.disconnect();

    _device = null;
    _treadmillChar = null;
    _controlPointChar = null;

    await _notifySub?.cancel();

    _buffer.clear();

    await _controlPointSub?.cancel();
    _hasControlPermission = false;
    _controlCompleter = null;

    state = const FtmsState();
  }

  // =========================
  // COMMAND
  // =========================
  Future<void> _ensureControl() async {
    if (_hasControlPermission) return;
    await requestControl();
  }

  Future<FtmsControlResponse> _sendControlCommand(
    List<int> data, {
    required int expectedOpCode,
  }) async {
    print('_sendControlCommand ====> 1');
    if (_controlPointChar == null) {
      throw Exception('Control Point characteristic not found');
    }
    print('_sendControlCommand ====> 2');
    if (_controlCompleter != null && !_controlCompleter!.isCompleted) {
      throw Exception('FTMS control command already in progress');
    }

    _controlCompleter = Completer<FtmsControlResponse>();
    print('_sendControlCommand ====> 3');
    await _controlPointChar!.write(data, withoutResponse: false);
    print('_sendControlCommand ====> 4');
    final response = await _controlCompleter!.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        throw Exception('FTMS control command timeout');
      },
    );
    print('_sendControlCommand ====> 5 ${response}');

    if (response.requestOpCode != expectedOpCode) {
      throw Exception('Unexpected FTMS response: $response');
    }

    print('_sendControlCommand ====> 6');
    return response;
  }

  void _handleControlPoint(List<int> data) {
    if (data.length < 3) return;

    final responseOpCode = data[0];

    if (responseOpCode != FtmsControlOpCode.responseCode) {
      return;
    }

    final response = FtmsControlResponse(
      requestOpCode: data[1],
      resultCode: data[2],
      raw: data,
    );

    if (_controlCompleter != null && !_controlCompleter!.isCompleted) {
      _controlCompleter!.complete(response);
    }
  }

  // =========================
  // 🔥 FTMS DATA HANDLER
  // =========================
  void _handleIncoming(List<int> data) {
    if (data.length < 2) return;

    final flags = data[0] | (data[1] << 8);

    final moreData = (flags & 0x0001) != 0;

    _buffer.addAll(data);

    if (!moreData) {
      final fullPacket = List<int>.from(_buffer);

      _buffer.clear();

      /// 👉 теперь у тебя ВСЕГДА полный пакет
      final parsed = parseFtms(fullPacket);

      // print('parsed ====> $parsed');

      state = state.copyWith(lastRawData: fullPacket);
    }
  }

  // =========================
  // HELPERS
  // =========================
  bool _hasFtmsService(ScanResult result) {
    if (result.advertisementData.serviceUuids.contains(FtmsUuids.service)) {
      return true;
    }

    final name = result.device.platformName.toLowerCase();

    return name.contains("tread") ||
        name.contains("run") ||
        name.contains("fit");
  }

  void _dispose() {
    _scanSub?.cancel();
    _notifySub?.cancel();
    _device?.disconnect();
    _controlPointSub?.cancel();
  }

  /// controls===========>
  Future<void> requestControl() async {
    print('============> requestControl');
    final response = await _sendControlCommand([
      FtmsControlOpCode.requestControl,
    ], expectedOpCode: FtmsControlOpCode.requestControl);

    print('============> requestControl ${response}');
    if (!response.isSuccess) {
      throw Exception('Request control failed: $response');
    }
    print('============> requestControl 123123123a123');
    _hasControlPermission = true;
  }

  Future<void> start() async {
    print('============> start');
    await _ensureControl();

    final response = await _sendControlCommand([
      FtmsControlOpCode.startOrResume,
    ], expectedOpCode: FtmsControlOpCode.startOrResume);

    print('============> start $response');
    if (!response.isSuccess) {
      throw Exception('Start failed: $response');
    }
  }

  Future<void> stop() async {
    await _ensureControl();

    final response = await _sendControlCommand([
      FtmsControlOpCode.stopOrPause,
      0x01, // Stop
    ], expectedOpCode: FtmsControlOpCode.stopOrPause);

    if (!response.isSuccess) {
      throw Exception('Stop failed: $response');
    }
  }

  Future<void> pause() async {
    await _ensureControl();

    final response = await _sendControlCommand([
      FtmsControlOpCode.stopOrPause,
      0x02, // Pause
    ], expectedOpCode: FtmsControlOpCode.stopOrPause);

    if (!response.isSuccess) {
      throw Exception('Pause failed: $response');
    }
  }

  Future<void> setSpeed(double speedKmH) async {
    await _ensureControl();

    final rawSpeed = (speedKmH * 100).round();

    final response = await _sendControlCommand([
      FtmsControlOpCode.setTargetSpeed,
      rawSpeed & 0xFF,
      (rawSpeed >> 8) & 0xFF,
    ], expectedOpCode: FtmsControlOpCode.setTargetSpeed);

    if (!response.isSuccess) {
      throw Exception('Set speed failed: $response');
    }
  }

  Future<void> setInclination(double percent) async {
    await _ensureControl();

    final rawIncline = (percent * 10).round();

    final response = await _sendControlCommand([
      FtmsControlOpCode.setTargetInclination,
      rawIncline & 0xFF,
      (rawIncline >> 8) & 0xFF,
    ], expectedOpCode: FtmsControlOpCode.setTargetInclination);

    if (!response.isSuccess) {
      throw Exception('Set inclination failed: $response');
    }
  }
}
