import 'package:bogge_app/features/ftms/models/ftms_uuids_model.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

bool checkIsTreadmill(ScanResult result) {
  if (!result.advertisementData.connectable) {
    return false;
  }

  final serviceUuids = result.advertisementData.serviceUuids;

  if (!serviceUuids.contains(FtmsUuids.service)) {
    return false;
  }

  final serviceData = result.advertisementData.serviceData;

  final ftmsData = serviceData[FtmsUuids.service];

  // fallback
  if (ftmsData == null || ftmsData.length < 3) {
    return true;
  }

  final flags = ftmsData[0];

  final isAvailable = (flags & 0x01) != 0;

  final machineType = ftmsData[1] | (ftmsData[2] << 8);

  final isTreadmill = (machineType & (1 << 0)) != 0;

  return isAvailable && isTreadmill;
}
