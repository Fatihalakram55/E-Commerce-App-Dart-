import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  // Simpan Session
  static Future<void> login(String username) async {
    // membuat objek shared preferences
    final prefs = await SharedPreferences.getInstance();
    // mengatur user yg sudah login
    // dipakai nanti untuk menentukan login (isLogin ? home : login)
    await prefs.setBool('isLogin', true);
    // menyimpan akun
    await prefs.setString('username', username);
  } 

  // cek sudah login apa blm
  static Future<bool> isLogin() async {
    final prefs = await SharedPreferences.getInstance();

    // cek apakah sdh login
    // ?? berfungsi untuk jika null maka false
    return prefs.getBool('isLogin') ?? false;
  }

  // ambil username
  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    // hapus data session
    await prefs.remove('isLogin',);
    await prefs.remove('username',);
  }
}