import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothAdapterStateModel {
  final bool isOn;
  final BluetoothAdapterState adapterState;

  const BluetoothAdapterStateModel({
    required this.isOn,
    required this.adapterState,
  });

  const BluetoothAdapterStateModel.initial()
    : isOn = false,
      adapterState = BluetoothAdapterState.unknown;

  BluetoothAdapterStateModel copyWith({
    bool? isOn,
    BluetoothAdapterState? adapterState,
  }) {
    return BluetoothAdapterStateModel(
      isOn: isOn ?? this.isOn,
      adapterState: adapterState ?? this.adapterState,
    );
  }
}
