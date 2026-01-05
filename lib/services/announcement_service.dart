import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/announcement_model.dart';

class AnnouncementService {
  static const String baseUrl = "http://10.0.2.2:8000/api";

  /// Ambil semua pengumuman (dengan pagination & optional search)
  static Future<List<Announcement>> getAnnouncements({
    int page = 1,
    int perPage = 10,
    String? search,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'per_page': perPage.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final uri =
          Uri.parse("$baseUrl/announcements").replace(queryParameters: queryParams);
      print("GET: $uri");

      final res = await http
          .get(uri)
          .timeout(const Duration(seconds: 10)); // tambahkan timeout biar aman

      print("Response [${res.statusCode}]: ${res.body}");

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);

        // Antisipasi format response bisa berupa {"data": [...]} atau langsung [...]
        final data = body['data'] ?? body;

        if (data is List) {
          return data
              .map<Announcement>((e) => Announcement.fromJson(e))
              .toList();
        } else {
          print("Format data tidak sesuai (bukan List)");
          return [];
        }
      } else {
        throw Exception("Gagal load pengumuman: ${res.statusCode}");
      }
    } catch (e) {
      print("Error getAnnouncements(): $e");
      return [];
    }
  }
}
