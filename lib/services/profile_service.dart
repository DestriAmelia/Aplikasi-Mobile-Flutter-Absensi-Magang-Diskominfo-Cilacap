// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'auth_service.dart';
// import '../models/profile_model.dart';

// class ProfileService {
//   final String baseUrl = "http://10.0.2.2:8000/api"; // ganti port sesuai Laravel

//   // Ambil token dari AuthService
//   Future<String?> getToken() async => await AuthService.getToken();

//   // Header umum
//   Future<Map<String, String>> get _headers async {
//     final t = await getToken();
//     return {
//       "Accept": "application/json",
//       "Content-Type": "application/json",
//       if (t != null) "Authorization": "Bearer $t",
//     };
//   }

//   // GET Profile (mengambil dari token user)
//   Future<ProfileModel> getProfile() async {
//     final headers = await _headers;
//     final start = DateTime.now();

//     final res = await http
//         .get(Uri.parse("$baseUrl/profile"), headers: headers)
//         .timeout(const Duration(seconds: 5));

//     final end = DateTime.now();
//     print("⏳ Waktu ambil profile: ${end.difference(start).inMilliseconds} ms");
//     print("🧾 Response Profile: ${res.statusCode} ${res.body}");

//     if (res.statusCode == 200) {
//       final body = jsonDecode(res.body);
//       final profileData = body['profile']; // Ambil profile dari response
//       if (profileData == null) {
//         throw Exception("Profile tidak ditemukan di server.");
//       }
//       return ProfileModel.fromJson(profileData);
//     } else if (res.statusCode == 401) {
//       throw Exception("Token invalid atau expired. Silakan login ulang.");
//     } else {
//       throw Exception("Gagal memuat profil: ${res.body}");
//     }
//   }

//   // PUT - Update profile
//   Future<bool> updateProfile(ProfileModel profile) async {
//     try {
//       final headers = await _headers;
//       final res = await http.put(
//         Uri.parse("$baseUrl/profile/update"),
//         headers: headers,
//         body: jsonEncode(profile.toJson()),
//       ).timeout(const Duration(seconds: 5));

//       print("📦 Update Profile Response: ${res.statusCode} → ${res.body}");
//       return res.statusCode == 200;
//     } catch (e) {
//       print("🔥 Error updateProfile: $e");
//       return false;
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/profile_model.dart';

class ProfileService {
  final String baseUrl = "http://10.0.2.2:8000/api"; // ✅ untuk emulator Android

  /// 🔹 Ambil token login dari AuthService
  Future<String?> getToken() async => await AuthService.getToken();

  /// 🔹 Header umum untuk semua request
  Future<Map<String, String>> get _headers async {
    final token = await getToken();
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  /// 🔹 GET Profile (ambil data dari token user)
 Future<ProfileModel> getProfile() async {
  try {
    final headers = await _headers;
    final url = Uri.parse("$baseUrl/profile");

    final res = await http
        .get(url, headers: headers)
        .timeout(const Duration(seconds: 15));

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);

      // karena controller return: { "success": true, "data": {...} }
      final profileData = body['profile'];

      if (profileData == null) {
        throw Exception("Data profile kosong");
      }

      return ProfileModel.fromJson(profileData);
    } else if (res.statusCode == 401) {
      throw Exception("Token kadaluarsa, login ulang.");
    } else {
      throw Exception("Gagal memuat profil: ${res.body}");
    }
  } catch (e) {
    print("🔥 Exception getProfile(): $e");
    throw Exception("Gagal memuat profil: $e");
  }
}

// update profile
  Future<bool> updateProfile(ProfileModel profile) async {
  try {
    final headers = await _headers;
    final url = Uri.parse("$baseUrl/profile/update");

    print("➡️ PUT Update Profile: $url");
    print("📦 Headers: $headers");
    final bodyJson = jsonEncode(profile.toJson());
    print("📤 Body: $bodyJson");

    final res = await http
        .put(url, headers: headers, body: bodyJson)
        .timeout(const Duration(seconds: 15));

    print("⬅️ Response Update Profile [${res.statusCode}]: ${res.body}");

    // Success
    if (res.statusCode == 200 || res.statusCode == 201) {
      // optionally parse and return message: final json = jsonDecode(res.body);
      return true;
    }

    // Validation error from Laravel
    if (res.statusCode == 422) {
      final json = jsonDecode(res.body);
      print("❗ Validation errors: ${json['errors'] ?? json}");
      return false;
    }

    // Unauthorized
    if (res.statusCode == 401 || res.statusCode == 403) {
      print("⚠️ Unauthorized. Token maybe invalid/expired.");
      return false;
    }

    // Other errors - show server message if available
    try {
      final json = jsonDecode(res.body);
      print("❌ Server message: ${json['message'] ?? json}");
    } catch (_) {
      print("❌ Unknown server response: ${res.body}");
    }

    return false;
  } catch (e) {
    print("🔥 Error updateProfile(): $e");
    return false;
  }
}

}
