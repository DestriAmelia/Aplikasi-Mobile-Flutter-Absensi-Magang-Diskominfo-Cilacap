import 'package:intl/intl.dart';

class AttendanceModel {
  final int id;
  final int idSertifikat;
  final DateTime tanggal; // format DateTime untuk kalender
  final String status;
  final String? location;
  final String? notes;
  final String? time;
  final String approvedStatus;

  AttendanceModel({
    required this.id,
    required this.idSertifikat,
    required this.tanggal,
    required this.status,
    this.location,
    this.notes,
    this.time,

    
    required this.approvedStatus,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    final rawDate = (json['date'] ?? json['tanggal'] ?? '').toString().trim();
    DateTime parsedDate;

    try {
      if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(rawDate)) {
        // Format "YYYY-MM-DD"
        parsedDate = DateTime.parse(rawDate);
      } else {
        try {
          // Format Inggris → "14 October 2025"
          parsedDate = DateFormat("d MMMM yyyy", "en_US").parse(rawDate);
        } catch (_) {
          // Format Indonesia → "14 Oktober 2025"
          parsedDate = DateFormat("d MMMM yyyy", "id_ID").parse(rawDate);
        }
      }
    } catch (e) {
      print("⚠️ Gagal parsing tanggal absensi: $rawDate ($e)");
      parsedDate = DateTime.now();
    }

    return AttendanceModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      idSertifikat: json['id_sertifikat'] is int
          ? json['id_sertifikat']
          : int.tryParse(json['id_sertifikat']?.toString() ?? '0') ?? 0,
      tanggal: parsedDate,
      status: json['status']?.toString() ?? '-',
      location: json['location']?.toString(),
      notes: (json['notes'] ?? json['keterangan'] ?? '').toString(),
      time: json['time']?.toString(),

      // 🟢 Tambahin mapping dari backend
      approvedStatus: json['approved_status']?.toString() ?? "",
    );
  }

  /// Format tanggal tampilan (Indonesia)
  String get formattedDate =>
      DateFormat("d MMMM yyyy", "id_ID").format(tanggal);
}
