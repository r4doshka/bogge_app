import 'dart:typed_data';

import 'package:bogge_app/features/bluetooth/models/ftms_data.dart';

FtmsData parseFtms(List<int> data) {
  final bytes = ByteData.sublistView(Uint8List.fromList(data));

  int offset = 0;

  bool canRead(int size) => offset + size <= data.length;

  // =========================
  // FLAGS
  // =========================
  if (!canRead(2)) return _empty();

  final flags = bytes.getUint16(offset, Endian.little);
  offset += 2;

  bool hasAvgSpeed = (flags & (1 << 1)) != 0;
  bool hasDistance = (flags & (1 << 2)) != 0;
  bool hasIncline = (flags & (1 << 3)) != 0;
  bool hasElevation = (flags & (1 << 4)) != 0;
  bool hasInstantPace = (flags & (1 << 5)) != 0;
  bool hasAvgPace = (flags & (1 << 6)) != 0;
  bool hasEnergy = (flags & (1 << 7)) != 0;
  bool hasHeartRate = (flags & (1 << 8)) != 0;
  bool hasMet = (flags & (1 << 9)) != 0;
  bool hasElapsedTime = (flags & (1 << 10)) != 0;
  bool hasRemainingTime = (flags & (1 << 11)) != 0;
  bool hasForcePower = (flags & (1 << 12)) != 0;

  // =========================
  // SPEED
  // =========================
  if (!canRead(2)) return _empty();

  final speedRaw = bytes.getUint16(offset, Endian.little);
  final speed = speedRaw / 100;
  offset += 2;

  // =========================
  // OPTIONAL
  // =========================

  if (hasAvgSpeed && canRead(2)) offset += 2;

  double? distance;
  if (hasDistance && canRead(4)) {
    final raw = bytes.getUint32(offset, Endian.little);
    distance = raw / 1000;
    offset += 4;
  }

  double? incline;
  if (hasIncline && canRead(4)) {
    final raw = bytes.getInt16(offset, Endian.little);
    incline = raw == 0x7FFF ? null : raw / 10;
    offset += 2;

    offset += 2; // ramp
  }

  if (hasElevation && canRead(4)) offset += 4;
  if (hasInstantPace && canRead(2)) offset += 2;
  if (hasAvgPace && canRead(2)) offset += 2;

  int? calories;
  if (hasEnergy && canRead(5)) {
    final total = bytes.getUint16(offset, Endian.little);
    calories = total == 0xFFFF ? null : total;
    offset += 2;

    offset += 2;
    offset += 1;
  }

  int? heartRate;
  if (hasHeartRate && canRead(1)) {
    heartRate = bytes.getUint8(offset);
    offset += 1;
  }

  if (hasMet && canRead(1)) offset += 1;

  int? elapsedTime;
  if (hasElapsedTime && canRead(2)) {
    elapsedTime = bytes.getUint16(offset, Endian.little);
    offset += 2;
  }

  if (hasRemainingTime && canRead(2)) offset += 2;
  if (hasForcePower && canRead(4)) offset += 4;

  return FtmsData(
    speed: speed,
    distance: distance,
    incline: incline,
    calories: calories,
    heartRate: heartRate,
    elapsedTime: elapsedTime,
  );
}

FtmsData _empty() {
  return const FtmsData(speed: 0);
}
