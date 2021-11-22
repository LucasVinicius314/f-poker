import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  static Future<String?> getAutoEmail() async {
    return (await _prefs).getString('auto_email');
  }

  static Future<void> setAutoEmail(String? autoEmail) async {
    final prefs = await _prefs;

    if (autoEmail == null)
      await prefs.remove('auto_email');
    else
      await prefs.setString('auto_email', autoEmail);
  }
}
