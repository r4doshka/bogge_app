class FtmsData {
  final double speed; // km/h
  final double? distance; // km
  final double? incline; // %
  final int? calories; // kcal
  final int? heartRate; // bpm
  final int? elapsedTime; // sec

  const FtmsData({
    required this.speed,
    this.distance,
    this.incline,
    this.calories,
    this.heartRate,
    this.elapsedTime,
  });

  @override
  String toString() {
    return '''
speed: $speed km/h
distance: $distance km
incline: $incline %
calories: $calories kcal
heartRate: $heartRate bpm
time: $elapsedTime sec
''';
  }
}

class FtmsControlOpCode {
  static const requestControl = 0x00;
  static const reset = 0x01;
  static const setTargetSpeed = 0x02;
  static const setTargetInclination = 0x03;
  static const startOrResume = 0x07;
  static const stopOrPause = 0x08;
  static const responseCode = 0x80;
}

class FtmsResultCode {
  static const success = 0x01;
  static const notSupported = 0x02;
  static const invalidParameter = 0x03;
  static const operationFailed = 0x04;
  static const controlNotPermitted = 0x05;
}

class FtmsControlResponse {
  final int requestOpCode;
  final int resultCode;
  final List<int> raw;

  const FtmsControlResponse({
    required this.requestOpCode,
    required this.resultCode,
    required this.raw,
  });

  bool get isSuccess => resultCode == FtmsResultCode.success;

  @override
  String toString() {
    return 'FtmsControlResponse(requestOpCode: $requestOpCode, resultCode: $resultCode, raw: $raw)';
  }
}
