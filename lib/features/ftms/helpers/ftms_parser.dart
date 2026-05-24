import 'dart:typed_data';

import 'package:bogge_app/features/ftms/models/ftms_data.dart';

FtmsData parseFtms(List<int> data) {
  final bytes = ByteData.sublistView(Uint8List.fromList(data));

  int offset = 0;

  bool canRead(int size) => offset + size <= data.length;

  if (!canRead(2)) return _empty();

  final flags = bytes.getUint16(offset, Endian.little);
  offset += 2;

  final hasInstantSpeed = (flags & (1 << 0)) == 0;
  final hasAvgSpeed = (flags & (1 << 1)) != 0;
  final hasDistance = (flags & (1 << 2)) != 0;
  final hasIncline = (flags & (1 << 3)) != 0;
  final hasElevation = (flags & (1 << 4)) != 0;
  final hasInstantPace = (flags & (1 << 5)) != 0;
  final hasAvgPace = (flags & (1 << 6)) != 0;
  final hasEnergy = (flags & (1 << 7)) != 0;
  final hasHeartRate = (flags & (1 << 8)) != 0;
  final hasMet = (flags & (1 << 9)) != 0;
  final hasElapsedTime = (flags & (1 << 10)) != 0;
  final hasRemainingTime = (flags & (1 << 11)) != 0;
  final hasForcePower = (flags & (1 << 12)) != 0;

  double speed = 0;

  if (hasInstantSpeed) {
    if (!canRead(2)) return _empty();

    final speedRaw = bytes.getUint16(offset, Endian.little);
    speed = speedRaw / 100;
    offset += 2;
  }

  if (hasAvgSpeed && canRead(2)) {
    offset += 2;
  }

  double? distance;
  if (hasDistance && canRead(3)) {
    final b0 = bytes.getUint8(offset);
    final b1 = bytes.getUint8(offset + 1);
    final b2 = bytes.getUint8(offset + 2);

    final raw = b0 | (b1 << 8) | (b2 << 16);

    distance = raw / 1000;
    offset += 3;
  }

  double? incline;
  if (hasIncline && canRead(4)) {
    final raw = bytes.getInt16(offset, Endian.little);
    incline = raw == 0x7FFF ? null : raw / 10;
    offset += 2;

    offset += 2; // ramp angle setting
  }

  if (hasElevation && canRead(3)) {
    offset += 3;
  }

  if (hasInstantPace && canRead(2)) {
    offset += 2;
  }

  if (hasAvgPace && canRead(2)) {
    offset += 2;
  }

  int? calories;
  if (hasEnergy && canRead(5)) {
    final total = bytes.getUint16(offset, Endian.little);

    calories = total == 0xFFFF ? null : total;

    offset += 2; // total energy
    offset += 2; // energy per hour
    offset += 1; // energy per minute
  }

  int? heartRate;
  if (hasHeartRate && canRead(1)) {
    heartRate = bytes.getUint8(offset);
    offset += 1;
  }

  if (hasMet && canRead(1)) {
    offset += 1;
  }

  int? elapsedTime;
  if (hasElapsedTime && canRead(2)) {
    elapsedTime = bytes.getUint16(offset, Endian.little);
    offset += 2;
  }

  if (hasRemainingTime && canRead(2)) {
    offset += 2;
  }

  if (hasForcePower && canRead(4)) {
    offset += 4;
  }

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
