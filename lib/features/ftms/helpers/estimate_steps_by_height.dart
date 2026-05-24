int estimatedStepsByHeight({
  required double heightCm,
  required double distance,
}) {
  if (distance <= 0 || heightCm <= 0) return 0;

  final strideLengthMeters = heightCm * 0.415 / 100;

  return ((distance * 1000) / strideLengthMeters).round();
}
