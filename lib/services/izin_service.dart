import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/izin_model.dart';
import 'auth_service.dart';

class IzinService {
  static const String baseUrl = AuthService.baseUrl;

  // Ambil semua izin
  static Future<List<IzinModel>> getIzin() async {
    final token = await AuthService.getTokenAsync();

    final res = await http.get(
      Uri.parse('$baseUrl/izin'),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);

      List<dynamic> list;
      if (decoded is Map && decoded.containsKey('data')) {
        list = decoded['data']; // Laravel biasanya return { data: [...] }
      } else if (decoded is List) {
        list = decoded;
      } else {
        list = [];
      }

      return list.map((e) => IzinModel.fromJson(Map<String, dynamic>.from(e))).toList();
    } else {
      throw Exception('Gagal mengambil izin: ${res.body}');
    }
  }

  // Ajukan izin baru
  static Future<bool> ajukanIzin({required String alasan}) async {
    final token = await AuthService.getTokenAsync();
    if (token == null) throw Exception("User belum login");

    final res = await http.post(
      Uri.parse('$baseUrl/izin'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'alasan': alasan,
      },
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return true;
    } else {
      throw Exception('Gagal mengajukan izin: ${res.body}');
    }
  }
}
