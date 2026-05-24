import 'package:bogge_app/features/ftms/models/ftms_data.dart';
import 'package:bogge_app/features/ftms/models/paired_ftms_devices.dart';
import 'package:bogge_app/utils/enums.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class FtmsState {
  final ScanStatus scanStatus;
  final ConnectionStatus connectionStatus;
  final TreadmillStatus treadmillStatus;
  final FtmsData? workoutData;
  final List<int>? lastRawData;
  final double? targetSpeed;
  final List<PairedFtmsDevice> savedDevices;
  final DeviceIdentifier? connectingDeviceId;
  final List<ScanResult> devices;
  final BluetoothDevice? device;
  final String? error;

  const FtmsState({
    this.scanStatus = ScanStatus.initial,
    this.connectionStatus = ConnectionStatus.initial,
    this.treadmillStatus = TreadmillStatus.idle,
    this.devices = const [],
    this.savedDevices = const [],
    this.device,
    this.lastRawData,
    this.workoutData,
    this.error,
    this.connectingDeviceId,
    this.targetSpeed,
  });

  FtmsState copyWith({
    ScanStatus? scanStatus,
    ConnectionStatus? connectionStatus,
    List<ScanResult>? devices,
    BluetoothDevice? device,
    FtmsData? workoutData,
    List<int>? lastRawData,
    bool clearWorkoutData = false,
    String? error,
    DeviceIdentifier? connectingDeviceId,
    bool clearConnectingDeviceId = false,
    List<PairedFtmsDevice>? savedDevices,
    TreadmillStatus? treadmillStatus,
    double? targetSpeed,
    bool clearTargetSpeed = false,
  }) {
    return FtmsState(
      scanStatus: scanStatus ?? this.scanStatus,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      devices: devices ?? this.devices,
      device: device ?? this.device,
      workoutData: clearWorkoutData ? null : workoutData ?? this.workoutData,
      lastRawData: lastRawData ?? this.lastRawData,
      error: error,
      connectingDeviceId: clearConnectingDeviceId
          ? null
          : connectingDeviceId ?? this.connectingDeviceId,
      savedDevices: savedDevices ?? this.savedDevices,
      treadmillStatus: treadmillStatus ?? this.treadmillStatus,
      targetSpeed: clearTargetSpeed ? null : targetSpeed ?? this.targetSpeed,
    );
  }

  @override
  String toString() {
    return 'workoutData: $workoutData isConnected: ${connectionStatus.name} scanStatus: ${scanStatus.name}, devices: $devices, savedDevices: $savedDevices, connectingDeviceId: $connectingDeviceId, device: $device, error: $error';
  }
}
