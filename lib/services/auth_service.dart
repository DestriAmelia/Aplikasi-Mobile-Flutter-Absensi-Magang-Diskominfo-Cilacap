import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../utils/session_manager.dart';

class AuthService {
  // gunakan static supaya bisa diakses tanpa instance
  static const String baseUrl = "http://10.0.2.2:8000/api";

  // ---------- instance methods ----------
  Future<UserModel> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Accept': 'application/json'},
      body: {"username": username, "password": password},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);

      // Laravel mengembalikan: { success, message, user, profile, token }
      // Atau kadang hanya user + token di top-level. Kita tangani keduanya.
      Map<String, dynamic> userJson;
      if (body.containsKey('user') && body['user'] is Map) {
        userJson = Map<String, dynamic>.from(body['user']);
      } else {
        userJson = Map<String, dynamic>.from(body);
      }

      final String? token = (body['token'] ?? userJson['token'])?.toString();

      // Pastikan kita memasukkan token ke json saat membangun UserModel
      final merged = Map<String, dynamic>.from(userJson);
      if (token != null) merged['token'] = token;

      final user = UserModel.fromJson(merged);

// // SIMPAN TOKEN TANPA SYARAT
// if (token != null) {
//   await SessionManager.saveToken(token);
// }

// // SIMPAN ID SERTIFIKAT JIKA ADA
// if (user.idSertifikat != null) {
//   await SessionManager.saveIdSertifikat(user.idSertifikat!);
// }


      return user;
    } else {
      throw Exception("Login gagal: ${response.body}");
    }
  }

  Future<void> register(String username, String password,
      {String role = 'siswa'}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Accept': 'application/json'},
      body: {"username": username, "password": password, "role": role},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Register gagal: ${response.body}");
    }
  }

  // Future<void> logout() async {
  //   await SessionManager.clearSession();
  // }

  Future<void> logout() async {
  final token = await SessionManager.getToken();
  if (token != null) {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        print("Gagal logout di server: ${response.body}");
      }
    } catch (e) {
      print("Error saat logout: $e");
    }
  }

  // hapus session lokal apapun hasil dari API
  await SessionManager.clearSession();
}


  // ---------- static helpers untuk kompatibilitas ----------
  // Ambil token dari storage (SessionManager)
  static Future<String?> getTokenAsync() async {
    return await SessionManager.getToken();
  }

  // alias (beberapa file memanggil getToken())
  static Future<String?> getToken() => getTokenAsync();

  // ambil id sertifikat
  static Future<int?> getIdSertifikatAsync() async {
    return await SessionManager.getIdSertifikat();
  }

  // ---------- convenience helpers (attendance proxy) ----------
  // Jika code lama memanggil AuthService.getTodayAbsensi()
  static Future<Map<String, dynamic>> getTodayAbsensi() async {
    final token = await getTokenAsync();
    if (token == null) throw Exception('User belum login (token null)');

    final res = await http.get(
      Uri.parse('$baseUrl/attendance/today'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      // return map (controller mengembalikan object status/message)
      if (decoded is Map<String, dynamic>) return decoded;
      return {'data': decoded};
    } else {
      throw Exception('Gagal mengambil status presensi hari ini: ${res.body}');
    }
  }

  /// Ambil recent history atau full history (full=true untuk /attendance/history)
  static Future<List<dynamic>> getAbsensi({bool full = false}) async {
    final token = await getTokenAsync();
    if (token == null) throw Exception('User belum login (token null)');

    final path = full ? '/attendance/history' : '/attendance/recent';
    final res = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      if (decoded is Map && decoded.containsKey('data')) {
        return List<dynamic>.from(decoded['data']);
      }
      if (decoded is List) return decoded;
      return [];
    } else {
      throw Exception('Gagal mengambil data absensi: ${res.body}');
    }
  }

  // ---------- attendance helpers ----------
  static Future<Map<String, dynamic>> absenMasuk(Map<String, dynamic> data) async {
    final token = await getTokenAsync();
    if (token == null) throw Exception('User belum login (token null)');

    final response = await http.post(
      Uri.parse('$baseUrl/absensi'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: data,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal absen masuk: ${response.body}");
    }
  }

  static Future<Map<String, dynamic>> absenKeluar(int id, String jamKeluar) async {
    final token = await getTokenAsync();
    if (token == null) throw Exception('User belum login (token null)');

    final response = await http.put(
      Uri.parse('$baseUrl/absensi/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {"jam_keluar": jamKeluar},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal absen keluar: ${response.body}");
    }
  }

  // ---------- izin helpers (baru ditambah) ----------
  static Future<Map<String, dynamic>> ajukanIzin(Map<String, dynamic> data) async {
    final token = await getTokenAsync();
    if (token == null) throw Exception('User belum login (token null)');

    final response = await http.post(
      Uri.parse('$baseUrl/perizinan'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: data,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal mengajukan izin: ${response.body}");
    }
  }
}

// =========================
// KOMENTAR DARI KODE LAMA
// =========================

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:simagang_app/model/mahasiswa_model.dart';

// class AuthService {
//   static const String baseUrl = "http://10.0.2.2:8000/api";
//   static String? _token; // Token login disimpan di memory

//   // ================================
//   // 🔑 TOKEN & HEADERS
//   // ================================
//   static Map<String, String> get headers {
//     final map = {
//       "Content-Type": "application/json",
//       "Accept": "application/json",
//     };
//     if (_token != null && _token!.isNotEmpty) {
//       map["Authorization"] = "Bearer $_token";
//     }
//     return map;
//   }

//   static String? getToken() => _token;

//   static Future<String?> getTokenAsync() async {
//     if (_token != null && _token!.isNotEmpty) return _token;
//     await loadToken();
//     return _token;
//   }

//   static Future<void> saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString("token", token);
//     _token = token;
//   }

//   static Future<void> loadToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     _token = prefs.getString("token");
//   }

//   static Future<void> logout() async {
//     _token = null;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove("token");
//   }

//   // ================================
//   // 🔑 AUTH SECTION
//   // ================================
//   static Future<Map<String, dynamic>> login(
//       String username, String password) async {
//     try {
//       final url = Uri.parse("$baseUrl/login");
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "username": username,
//           "password": password,
//         }),
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data["token"] != null) {
//         await saveToken(data["token"]);
//         return {
//           "success": true,
//           "message": data["message"] ?? "Login berhasil",
//           "token": data["token"],
//           "user": data["user"],
//         };
//       } else {
//         return {
//           "success": false,
//           "message": data["message"] ?? "Login gagal",
//         };
//       }
//     } catch (e) {
//       return {
//         "success": false,
//         "message": "Tidak bisa konek ke server: $e",
//       };
//     }
//   }

//   static Future<Map<String, dynamic>> register(
//       String username, String password, String role) async {
//     try {
//       final url = Uri.parse("$baseUrl/register");
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "username": username,
//           "password": password,
//           "role": role,
//         }),
//       );

//       final data = jsonDecode(response.body);

//       if ((response.statusCode == 201 || response.statusCode == 200) &&
//           data["user"] != null) {
//         return {
//           "success": true,
//           "message": data["message"] ?? "Registrasi berhasil",
//           "user": data["user"],
//         };
//       } else {
//         return {
//           "success": false,
//           "message": data["message"] ?? "Registrasi gagal",
//         };
//       }
//     } catch (e) {
//       return {
//         "success": false,
//         "message": "Tidak bisa konek ke server: $e",
//       };
//     }
//   }

//   // ================================
//   // 👤 PROFILE SECTION
//   // ================================
//   static Future<Mahasiswa?> getProfile() async {
//     if (_token == null || _token!.isEmpty) {
//       await loadToken();
//     }

//     try {
//       final response =
//           await http.get(Uri.parse('$baseUrl/profile'), headers: headers);

//       if (response.statusCode == 200) {
//         final body = json.decode(response.body);

//         // antisipasi variasi struktur response
//         final data = body['profile'] ?? body['data'] ?? body['user'] ?? body;

//         return Mahasiswa.fromJson(data);
//       } else {
//         print(
//             "❌ Gagal ambil profile: ${response.statusCode} - ${response.body}");
//         return null;
//       }
//     } catch (e) {
//       print("⚠️ Error getProfile: $e");
//       return null;
//     }
//   }

//   // ================================
//   // 🕒 ABSENSI SECTION
//   // ================================
//   static Future<List<dynamic>> getAbsensi() async {
//     try {
//       final response =
//           await http.get(Uri.parse('$baseUrl/absensi'), headers: headers);

//       final body = jsonDecode(response.body);

//       if (response.statusCode == 200 && body["data"] != null) {
//         return body["data"];
//       } else {
//         throw Exception(
//             "Gagal ambil absensi: ${response.statusCode} - ${response.body}");
//       }
//     } catch (e) {
//       throw Exception("⚠️ Error getAbsensi: $e");
//     }
//   }

//   static Future<Map<String, dynamic>> absenMasuk(
//       Map<String, dynamic> data) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/absensi'),
//         headers: headers,
//         body: jsonEncode(data),
//       );
//       return jsonDecode(response.body);
//     } catch (e) {
//       return {"success": false, "message": "⚠️ Error absenMasuk: $e"};
//     }
//   }

//   static Future<Map<String, dynamic>> absenKeluar(
//       int id, String jamKeluar) async {
//     try {
//       final response = await http.put(
//         Uri.parse('$baseUrl/absensi/$id'),
//         headers: headers,
//         body: jsonEncode({"jam_keluar": jamKeluar}),
//       );
//       return jsonDecode(response.body);
//     } catch (e) {
//       return {"success": false, "message": "⚠️ Error absenKeluar: $e"};
//     }
//   }
// }
