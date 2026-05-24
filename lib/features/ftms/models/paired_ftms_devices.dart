import 'dart:convert';

class PairedFtmsDevice {
  final String remoteId;
  final String name;

  const PairedFtmsDevice({required this.remoteId, required this.name});

  Map<String, dynamic> toJson() {
    return {'remoteId': remoteId, 'name': name};
  }

  factory PairedFtmsDevice.fromJson(Map<String, dynamic> json) {
    return PairedFtmsDevice(
      remoteId: json['remoteId'] as String,
      name: json['name'] as String,
    );
  }

  String encode() => jsonEncode(toJson());

  factory PairedFtmsDevice.decode(String value) {
    return PairedFtmsDevice.fromJson(jsonDecode(value) as Map<String, dynamic>);
  }

  @override
  String toString() {
    return 'remoteId: $remoteId, name: $name';
  }
}
