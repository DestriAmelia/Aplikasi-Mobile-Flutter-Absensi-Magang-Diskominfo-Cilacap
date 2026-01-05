import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const _keyToken = "token";
  static const _keyIdSertifikat = "idSertifikat";

  /// Simpan token & idSertifikat setelah login
  static Future<void> saveSession(String token, int idSertifikat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setInt(_keyIdSertifikat, idSertifikat);
  }

  /// Ambil token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  /// Ambil idSertifikat
  static Future<int?> getIdSertifikat() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyIdSertifikat);
  }

  /// Hapus session (logout)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyIdSertifikat);
  }
}
