bool isSameDouble(double? a, double b) {
  if (a == null) return false;
  return a.toStringAsFixed(1) == b.toStringAsFixed(1);
}
