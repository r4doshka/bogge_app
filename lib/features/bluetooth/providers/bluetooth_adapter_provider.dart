import 'package:bogge_app/features/bluetooth/models/bluetooth_adapter_state.dart';
import 'package:bogge_app/features/bluetooth/notifiers/bluetooth_adapter_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final bluetoothAdapterProvider =
    NotifierProvider<BluetoothAdapterController, BluetoothAdapterStateModel>(
      BluetoothAdapterController.new,
    );
