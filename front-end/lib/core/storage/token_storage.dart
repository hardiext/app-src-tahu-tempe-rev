import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static Future save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  static Future<String?> get() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}