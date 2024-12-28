import 'package:shared_preferences/shared_preferences.dart';
// import '../models/user.dart';

class AuthService {
  static const String TOKEN_KEY = 'auth_token';
  static const String USERNAME_KEY = 'username';
  
  Future<bool> login(String username, String password) async {
    try {
      // Simulasi pengecekan login
      if (username == 'admin' && password == 'admin') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(TOKEN_KEY, 'dummy_token_${DateTime.now().millisecondsSinceEpoch}');
        await prefs.setString(USERNAME_KEY, username);
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(TOKEN_KEY);
      await prefs.remove(USERNAME_KEY);
    } catch (e) {
      print('Logout error: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(TOKEN_KEY);
      return token != null;
    } catch (e) {
      print('Check login status error: $e');
      return false;
    }
  }

  Future<String?> getUsername() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(USERNAME_KEY);
    } catch (e) {
      print('Get username error: $e');
      return null;
    }
  }
}