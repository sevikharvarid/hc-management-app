import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  Future<void> store(String key, dynamic value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value);
  }

  Future<dynamic> read(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    dynamic value = preferences.getString(key);
    return value;
  }

  void remove(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(key);
  }

  Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
