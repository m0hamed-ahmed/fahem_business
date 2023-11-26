import 'package:shared_preferences/shared_preferences.dart';

const String PREFERENCES_KEY_IS_ENGLISH = "PREFERENCES_KEY_IS_ENGLISH";
const String PREFERENCES_KEY_IS_LOGGED = "PREFERENCES_KEY_IS_LOGGED";
const String PREFERENCES_KEY_ACCOUNT_TYPE = "PREFERENCES_KEY_ACCOUNT_TYPE";
const String PREFERENCES_KEY_ACCOUNT = "PREFERENCES_KEY_ACCOUNT";

class CacheHelper {
  static late SharedPreferences _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    // clearData();
  }

  static Future<bool> setData({required String key, required dynamic value}) async {
    if(value.runtimeType == String) {return await _sharedPreferences.setString(key, value);}
    if(value.runtimeType == bool) {return await _sharedPreferences.setBool(key, value);}
    if(value.runtimeType == int) {return await _sharedPreferences.setInt(key, value);}
    return await _sharedPreferences.setDouble(key, value);
  }

  static dynamic getData({required String key}) {
    return _sharedPreferences.get(key);
  }

  static Future<bool> removeData({required String key}) async {
    return await _sharedPreferences.remove(key);
  }

  static Future<bool> clearData() async {
    return await _sharedPreferences.clear();
  }
}