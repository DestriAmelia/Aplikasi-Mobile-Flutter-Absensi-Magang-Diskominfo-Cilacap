// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'auth_service.dart';
// import '../models/attendance_model.dart';

// class AttendanceService {
//   // Pastikan baseUrl sesuai environment / emulator (10.0.2.2 untuk Android emulator)
//   final String baseUrl = "http://10.0.2.2:8000/api";
//   final String? token;

//   AttendanceService({this.token});

//   Future<String?> getToken() async {
//     if (token != null) return token;
//     return await AuthService.getToken();
//   }

//   Future<Map<String, String>> get _headers async {
//     final t = await getToken();
//     return {
//       "Accept": "application/json",
//       "Content-Type": "application/json",
//       if (t != null) "Authorization": "Bearer $t",
//     };
//   }

//   /// Ambil seluruh riwayat absensi (history / full history)
//   Future<List<AttendanceModel>> getAttendances(int idSertifikat) async {
//     final headers = await _headers;
//     final url = Uri.parse("$baseUrl/attendance/history?id_sertifikat=$idSertifikat");
//     print("➡️ GET Attendances: $url");

//     final res = await http.get(url, headers: headers).timeout(const Duration(seconds: 15));
//     print("⬅️ Response [${res.statusCode}]: ${res.body}");

//     if (res.statusCode != 200) {
//       // Jika token expired / 401, atau server error -> lempar exception berisi body
//       throw Exception("Gagal load absensi (status ${res.statusCode}): ${res.body}");
//     }

//     final decoded = jsonDecode(res.body);

//     // API Laravel kemungkinan mengembalikan { success:true, data: [...] } or { data: [...] }
//     List<dynamic> list;
//     if (decoded is List) {
//       list = decoded;
//     } else if (decoded is Map<String, dynamic>) {
//       if (decoded['data'] is List) {
//         list = decoded['data'] as List<dynamic>;
//       } else if (decoded['attendances'] is List) {
//         // fallback jika key berbeda
//         list = decoded['attendances'] as List<dynamic>;
//       } else {
//         // jika payload tidak sesuai, kembalikan list kosong
//         list = [];
//       }
//     } else {
//       list = [];
//     }

//     try {
//       return list.map((e) => AttendanceModel.fromJson(Map<String, dynamic>.from(e))).toList();
//     } catch (e) {
//       print("⚠️ Gagal mapping attendances -> AttendanceModel: $e");
//       return [];
//     }
//   }

//   /// Alternatif alias: ambil full history (sama fungsinya)
//   Future<List<AttendanceModel>> getFullHistory(int idSertifikat) async {
//     return getAttendances(idSertifikat);
//   }

//   /// Ambil status/absensi hari ini (endpoint /attendance/today)
//   Future<Map<String, dynamic>> getToday(int idSertifikat) async {
//     final headers = await _headers;
//     final url = Uri.parse("$baseUrl/attendance/today?id_sertifikat=$idSertifikat");
//     print("➡️ GET Today: $url");

//     final res = await http.get(url, headers: headers).timeout(const Duration(seconds: 10));
//     print("⬅️ Today Response [${res.statusCode}]: ${res.body}");

//     if (res.statusCode != 200) {
//       throw Exception("Gagal load absensi hari ini (${res.statusCode}): ${res.body}");
//     }

//     final body = jsonDecode(res.body);
//     if (body is Map<String, dynamic>) return body;
//     return {};
//   }

//   /// Presensi hadir
//  Future<bool> absenHadir(int idSertifikat, {String? location, String? notes}) async {
//   final headers = await _headers;
//   final url = Uri.parse("$baseUrl/attendance");
//   final payload = jsonEncode({
//     "id_sertifikat": idSertifikat,
//     "status": "Hadir",
//     "location": location ?? "",
//     "notes": notes ?? "",
//   });
//   final res = await http.post(url, headers: headers, body: payload);
//   final decoded = jsonDecode(res.body);
//   return (res.statusCode == 200 || res.statusCode == 201) && (decoded['success'] == true);
// }

//   /// Presensi izin
//   Future<bool> absenIzin(int idSertifikat, String notes) async {
//     final headers = await _headers;
//     final url = Uri.parse("$baseUrl/attendance/izin");
//     print("➡️ POST Izin: $url");

//     final payload = jsonEncode({
//       "id_sertifikat": idSertifikat,
//       "status": "Izin",
//       "notes": notes,
//     });

//     final res = await http.post(url, headers: headers, body: payload).timeout(const Duration(seconds: 15));
//     print("⬅️ Izin Response [${res.statusCode}]: ${res.body}");
//     return res.statusCode == 200 || res.statusCode == 201;
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/attendance_model.dart';

class AttendanceService {
  final String baseUrl = "http://10.0.2.2:8000/api";
  final String? token;

  AttendanceService({this.token});

  Future<String?> getToken() async {
    if (token != null) return token;
    return await AuthService.getToken();
  }

  Future<Map<String, String>> get _headers async {
    final t = await getToken();
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      if (t != null) "Authorization": "Bearer $t",
    };
  }

  Future<List<AttendanceModel>> getAttendances(int idSertifikat) async {
  final headers = await _headers;

  // 🟡 Tambahkan debug log di sini
  print("🔑 Token dikirim (getAttendances): ${headers['Authorization']}");
  print("📡 URL yang dipanggil: $baseUrl/attendance/history?id_sertifikat=$idSertifikat");

  final url = Uri.parse("$baseUrl/attendance/history?id_sertifikat=$idSertifikat");

  final res = await http.get(url, headers: headers).timeout(const Duration(seconds: 15));

  print("📡 Status Code: ${res.statusCode}");
  print("📦 Response Body: ${res.body}");

  if (res.statusCode != 200) throw Exception("Gagal load absensi: ${res.body}");

  final decoded = jsonDecode(res.body);
  List<dynamic> list;
  if (decoded is List) {
    list = decoded;
  } else if (decoded is Map<String, dynamic>) {
    if (decoded['data'] is List) list = decoded['data'];
    else if (decoded['attendances'] is List) list = decoded['attendances'];
    else list = [];
  } else {
    list = [];
  }

  return list.map((e) => AttendanceModel.fromJson(Map<String, dynamic>.from(e))).toList();
}

  Future<Map<String, dynamic>> getToday(int idSertifikat) async {
    final headers = await _headers;
    final url = Uri.parse("$baseUrl/attendance/today?id_sertifikat=$idSertifikat");

    final res = await http.get(url, headers: headers).timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) throw Exception("Gagal load absensi hari ini (${res.statusCode})");

    final body = jsonDecode(res.body);
    if (body is Map<String, dynamic>) return body;
    return {};
  }

  Future<bool> absenHadir(int idSertifikat, {String? location, String? notes}) async {
  final headers = await _headers;
  final url = Uri.parse("$baseUrl/attendance");

  final payload = jsonEncode({
    "id_sertifikat": idSertifikat,
    "status": "Hadir",
    "location": location ?? "",
    "notes": notes ?? "",
  });

  final res = await http.post(url, headers: headers, body: payload).timeout(const Duration(seconds: 15));
  final decoded = jsonDecode(res.body);
  return (res.statusCode == 200 || res.statusCode == 201) && (decoded['success'] == true);
}


Future<bool> absenIzin(int idSertifikat, String notes) async {
  final headers = await _headers;
  final url = Uri.parse("$baseUrl/attendance/izin");

  final payload = jsonEncode({
    "id_sertifikat": idSertifikat,
    "status": "Izin",
    "notes": notes,
  });

  final res = await http.post(url, headers: headers, body: payload).timeout(const Duration(seconds: 15));
  final decoded = jsonDecode(res.body);
  return (res.statusCode == 200 || res.statusCode == 201) && (decoded['success'] == true);
}

}
