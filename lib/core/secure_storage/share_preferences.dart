import 'package:shared_preferences/shared_preferences.dart';

class BaseStorage {
  static BaseStorage instance = BaseStorage._internal();

  late SharedPreferences prefs;

  factory BaseStorage() {
    return instance;
  }

  BaseStorage._internal();

  Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> setIntValue(String key, int value) async =>
      await prefs.setInt(key, value);

  Future<void> setDoubleValue(String key, double value) async =>
      await prefs.setDouble(key, value);

  Future<void> setStringValue(String key, String value) async =>
      await prefs.setString(key, value);

  Future<void> setBoolValue(String key, bool value) async =>
      await prefs.setBool(key, value);

  Future<void> setStringListValue(String key, List<String> value) async =>
      await prefs.setStringList(key, value);

  int getIntValue(String key) => prefs.getInt(key) ?? 0;

  double getDoubleValue(String key) => prefs.getDouble(key) ?? 0;

  String getStringValue(String key) => prefs.getString(key) ?? '';

  bool getBoolValue(String key) => prefs.getBool(key) ?? false;

  List<String> getStringListValue(String key) => prefs.getStringList(key) ?? [];

  Future<void> removeData(String key) async => await prefs.remove(key);

  T getValue<T>(String key) {
    if (T is int) {
      return getIntValue(key) as T;
    } else if (T is double) {
      return getDoubleValue(key) as T;
    } else if (T is bool) {
      return getBoolValue(key) as T;
    } else if (T is List) {
      return getStringListValue(key) as T;
    }
    return getStringValue(key) as T;
  }

  Future<void> setValue<T>(String key, T value) async {
    if (T is int) {
      await setIntValue(key, value as int);
    } else if (T is double) {
      await setDoubleValue(key, value as double);
    } else if (T is bool) {
      await setBoolValue(key, value as bool);
    } else if (T is List) {
      await setStringListValue(key, value as List<String>);
    }
    await setStringValue(key, value as String);
  }
}
