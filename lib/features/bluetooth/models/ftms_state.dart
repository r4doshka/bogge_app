import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class FtmsState {
  final bool isConnected;
  final bool isConnecting;
  final BluetoothDevice? device;
  final List<int>? lastRawData;
  final String? error;

  const FtmsState({
    this.isConnected = false,
    this.isConnecting = false,
    this.device,
    this.lastRawData,
    this.error,
  });

  FtmsState copyWith({
    bool? isConnected,
    bool? isConnecting,
    BluetoothDevice? device,
    List<int>? lastRawData,
    String? error,
  }) {
    return FtmsState(
      isConnected: isConnected ?? this.isConnected,
      isConnecting: isConnecting ?? this.isConnecting,
      device: device ?? this.device,
      lastRawData: lastRawData ?? this.lastRawData,
      error: error,
    );
  }
}
