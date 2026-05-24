import 'package:bogge_app/features/ftms/models/ftms_state.dart';
import 'package:bogge_app/features/ftms/notifiers/ftms_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final ftmsProvider = NotifierProvider<FtmsController, FtmsState>(
  FtmsController.new,
);
