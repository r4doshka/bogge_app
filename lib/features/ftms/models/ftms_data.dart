import 'package:easy_localization/easy_localization.dart';

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

  String formattedElapsedTime() {
    final duration = Duration(seconds: elapsedTime ?? 0);

    final minutes = duration.inMinutes.toString().padLeft(2, '0');

    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$minutes:$seconds,00';
  }

  String formattedSpeed([String locale = 'ru']) {
    return NumberFormat('0.0', locale).format(speed);
  }

  String formattedDistance([String locale = 'ru']) {
    if (distance == null) {
      return '0.00';
    }

    return NumberFormat('0.00', locale).format(distance);
  }

  String formattedIncline([String locale = 'ru']) {
    if (incline == null) {
      return '0.0';
    }

    return NumberFormat('0.0', locale).format(incline);
  }

  String get formattedCalories {
    return '${calories ?? 0}';
  }

  String get formattedHeartRate {
    return '${heartRate ?? 0}';
  }

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
