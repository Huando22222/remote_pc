import 'package:pc_remote/core/constants/pref_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  Future<String> getLocale() async {
    return _prefs.getString(PrefConstants.appLocale) ?? 'vi';
  }

  Future<String> getTheme() async {
    return _prefs.getString(PrefConstants.themeMode) ?? 'system';
  }

  String? getString(String key) => _prefs.getString(key);

  double? getDouble(String key) => _prefs.getDouble(key);

  bool? getBool(String key) => _prefs.getBool(key);

  Future<void> setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  Future<void> setDouble(String key, double value) {
    return _prefs.setDouble(key, value);
  }

  Future<void> setBool(String key, bool value) {
    return _prefs.setBool(key, value);
  }

  Future<void> remove(String key) {
    return _prefs.remove(key);
  }
}
