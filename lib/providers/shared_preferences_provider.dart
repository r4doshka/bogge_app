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
}
