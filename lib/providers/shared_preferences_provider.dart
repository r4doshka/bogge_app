import 'package:bogge_app/features/ftms/models/paired_ftms_devices.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final sharedPreferencesServiceProvider = Provider<SharedPreferencesService>((
  ref,
) {
  final preferences = ref.watch(sharedPreferencesProvider);
  return SharedPreferencesService(preferences);
});

class SharedPreferencesService {
  static const _pairedFtmsDevicesKey = 'pairedFtmsDevices';
  final SharedPreferences preferences;
  SharedPreferencesService(this.preferences);

  Future<bool> setSendEmailTimeByEmail(String time, String email) async {
    return preferences.setString('SendEmailTime$email', time);
  }

  String? getSendEmailTimeByEmail(String email) =>
      preferences.getString('SendEmailTime$email');

  Future<bool> removeSendEmailTimeByEmail(String email) async =>
      preferences.remove('SendEmailTime$email');

  Future<bool> setEnvBaseUrls(String env) async =>
      preferences.setString("selectedEnvironment", env);

  String? getEnvBaseUrls() => preferences.getString('selectedEnvironment');

  Future<bool> removeItem(String key) async => preferences.remove(key);

  List<PairedFtmsDevice> getPairedFtmsDevices() {
    final list = preferences.getStringList(_pairedFtmsDevicesKey) ?? [];

    return list.map(PairedFtmsDevice.decode).toList();
  }

  Future<bool> setPairedFtmsDevices(List<PairedFtmsDevice> devices) async {
    return preferences.setStringList(
      _pairedFtmsDevicesKey,
      devices.map((item) => item.encode()).toList(),
    );
  }

  Future<bool> addPairedFtmsDevice(PairedFtmsDevice device) async {
    final devices = getPairedFtmsDevices();

    final alreadyExists = devices.any(
      (item) => item.remoteId == device.remoteId,
    );

    if (alreadyExists) return true;

    return setPairedFtmsDevices([...devices, device]);
  }

  Future<bool> removePairedFtmsDevice(String remoteId) async {
    final devices = getPairedFtmsDevices();

    return setPairedFtmsDevices(
      devices.where((item) => item.remoteId != remoteId).toList(),
    );
  }
}
