import 'package:shared_preferences/shared_preferences.dart';

class CacheHandler {
  static Future<void> saveUserInfo({
    required String userName,
    required String phoneNumber,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName.trim());  
    await prefs.setString('phoneNumber', phoneNumber.trim());
    await prefs.setString('password', password.trim());
  }

  static Future<Map<String, String>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userName': prefs.getString('userName') ?? '',
      'phoneNumber': prefs.getString('phoneNumber') ?? '',
      'password': prefs.getString('password') ?? '',
    };
  }

  static Future<void> clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
