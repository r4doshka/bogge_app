import 'package:bogge_app/features/bluetooth/models/ftms_state.dart';
import 'package:bogge_app/features/bluetooth/notifiers/ftms_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final ftmsProvider = NotifierProvider<FtmsController, FtmsState>(
  FtmsController.new,
);
