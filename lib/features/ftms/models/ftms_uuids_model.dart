import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class FtmsUuids {
  // Fitness Machine Service
  static final service = Guid("00001826-0000-1000-8000-00805f9b34fb");

  // Characteristics
  static final treadmillData = Guid("00002ACD-0000-1000-8000-00805f9b34fb");
  static final controlPoint = Guid("00002AD9-0000-1000-8000-00805f9b34fb");
  static final feature = Guid("00002ACC-0000-1000-8000-00805f9b34fb");
}
