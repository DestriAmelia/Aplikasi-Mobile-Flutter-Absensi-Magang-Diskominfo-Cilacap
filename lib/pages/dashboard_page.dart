// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import '../widgets/sidebar_navbar.dart';
// import '../pages/announcement_page.dart';
// import '../models/announcement_model.dart';
// import '../models/profile_model.dart';
// import '../models/attendance_model.dart';
// import '../services/announcement_service.dart';
// import '../services/profile_service.dart';
// import '../services/attendance_service.dart';

// class DashboardPage extends StatefulWidget {
//   final int idSertifikat;
//   const DashboardPage({super.key, required this.idSertifikat});

//   @override
//   State<DashboardPage> createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   DateTime focusedDay = DateTime.now();
//   DateTime? selectedDay;

//   final ProfileService _profileService = ProfileService();
//   final AttendanceService _attendanceService = AttendanceService();
//   ProfileModel? _profile;
//   List<Announcement> pengumuman = [];
//   List<AttendanceModel> riwayatAbsensi = [];
//   bool loading = true;

//   Map<DateTime, bool> statusAnnouncement = {};

//   DateTime _normalizeDate(DateTime date) =>
//       DateTime(date.year, date.month, date.day);

//   @override
//   void initState() {
//     super.initState();
//     initializeDateFormatting('id_ID', null).then((_) => _initData());
//   }

//   Future<void> _initData() async {
//     await Future.wait([
//       _loadProfile(),
//       _loadPengumuman(),
//       _loadAttendance(),
//     ]);

//     // 🔹 Build statusAnnouncement map
//     statusAnnouncement.clear();
//     for (var a in pengumuman) {
//       try {
//         final key = _normalizeDate(DateTime.parse(a.createdAt));
//         statusAnnouncement[key] = true;
//       } catch (_) {}
//     }

//     setState(() => loading = false);
//   }

//   Future<void> _loadProfile() async {
//     try {
//       _profile = await _profileService.getProfile();
//     } catch (e) {
//       debugPrint("❌ Gagal memuat profil: $e");
//     }
//   }

//    Future<void> _loadPengumuman() async {
//   try {
//     final data = await AnnouncementService.getAnnouncements();
//     pengumuman = data.take(3).toList();

//     // Karena createdAt adalah String, kita parse dulu ke DateTime
//     for (var a in pengumuman) {
//       final parsed = DateTime.tryParse(a.createdAt);
//       if (parsed != null) {
//         // Jika mau dipakai untuk logika tanggal, buat variabel baru aja, jangan ubah field-nya
//         final normalized = _normalizeDate(parsed);
//         // Misal kamu cuma mau print tanggal tanpa jam:
//         debugPrint("Tanggal pengumuman: ${normalized.toIso8601String()}");
//       }
//     }
//   } catch (e) {
//     debugPrint("❌ Gagal memuat pengumuman: $e");
//   }
// }

// Future<void> _loadAttendance() async {
//   try {
//     riwayatAbsensi = await _attendanceService.getAttendances(widget.idSertifikat);

//     // tanggal sudah DateTime, jadi cukup seperti ini
//     for (var absen in riwayatAbsensi) {
//       final normalized = _normalizeDate(absen.tanggal);
//       // Karena field 'tanggal' final (tidak bisa diubah), buat variabel baru jika perlu
//       debugPrint("Tanggal absensi: ${normalized.toIso8601String()}");
//     }
//   } catch (e) {
//     debugPrint("❌ Gagal memuat absensi: $e");
//   }
// }

//   Map<DateTime, String> get statusAbsensi {
//     final map = <DateTime, String>{};
//     for (var absen in riwayatAbsensi) {
//       final key = _normalizeDate(absen.tanggal);
//       map[key] = absen.status;
//     }
//     return map;
//   }

//   Map<String, int> get statistik {
//     int hadir = 0, izin = 0, terlambat = 0;
//     for (final a in riwayatAbsensi) {
//       if (a.status == "Hadir") hadir++;
//       else if (a.status == "Izin") izin++;
//       else if (a.status == "Terlambat") terlambat++;
//     }
//     return {"Hadir": hadir, "Izin": izin, "Terlambat": terlambat};
//   }

//   /// 🔹 Bottom Sheet Gabungan Absensi + Pengumuman
//    void _showRiwayatGabunganBottomSheet(DateTime tanggal) {
//   final tanggalNormal = _normalizeDate(tanggal);

//   // 🔹 Ambil status absensi berdasarkan tanggal yang sudah dinormalisasi
//   final status = statusAbsensi[tanggalNormal];

//   // 🔹 Ambil pengumuman berdasarkan tanggal yang sudah dinormalisasi
//   final listPengumuman = pengumuman.where((a) {
//     try {
//       final createdAt = _normalizeDate(DateTime.parse(a.createdAt));
//       return createdAt == tanggalNormal;
//     } catch (_) {
//       return false;
//     }
//   }).toList();

//   if (status == null && listPengumuman.isEmpty) {
//     _showNoDataBottomSheet(tanggal);
//     return;
//   }

//   showModalBottomSheet(
//     context: context,
//     backgroundColor: Colors.white,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//     ),
//     builder: (_) => Padding(
//       padding: const EdgeInsets.all(18),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 40,
//               height: 5,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             const SizedBox(height: 15),

//             // 🔹 Riwayat Absensi
//             if (status != null) ...[
//               const Text("Riwayat Absensi",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//               const SizedBox(height: 10),
//               Container(
//                 decoration: BoxDecoration(
//                   color: status == "Hadir"
//                       ? const Color(0xFFD7F5E8)
//                       : status == "Izin"
//                           ? const Color(0xFFFFF4E6)
//                           : const Color(0xFFFFE3E6),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: status == "Hadir"
//                         ? Colors.green
//                         : status == "Izin"
//                             ? Colors.orange
//                             : Colors.redAccent,
//                     child: Icon(
//                       status == "Hadir"
//                           ? Icons.check_circle
//                           : status == "Izin"
//                               ? Icons.info_outline
//                               : Icons.timer,
//                       color: Colors.white,
//                     ),
//                   ),
//                   title: Text(
//                     status,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: status == "Hadir"
//                           ? Colors.green
//                           : status == "Izin"
//                               ? Colors.orange
//                               : Colors.redAccent,
//                     ),
//                   ),
//                   subtitle: Text(
//                     "Tanggal: ${DateFormat('d MMMM yyyy', 'id_ID').format(tanggal)}",
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],

//             // 🔹 Riwayat Pengumuman
//             if (listPengumuman.isNotEmpty) ...[
//               const Text("Riwayat Pengumuman",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//               const SizedBox(height: 10),
//               ...listPengumuman.map(
//                 (a) => Container(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Colors.blue.shade50, Colors.teal.shade50],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.shade300,
//                         blurRadius: 5,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: Colors.blue.shade300,
//                       child: const Icon(Icons.campaign, color: Colors.white),
//                     ),
//                     title: Text(a.title ?? "-",
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 16)),
//                     subtitle: Padding(
//                       padding: const EdgeInsets.only(top: 4),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(a.content ?? "",
//                               style:
//                                   const TextStyle(color: Colors.black87)),
//                           const SizedBox(height: 4),
//                           Text(
//                             _formatDate(a.createdAt),
//                             style: const TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.black38,
//                                 fontStyle: FontStyle.italic),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     ),
//   );
// }

//   void _showNoDataBottomSheet(DateTime tanggal) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//       ),
//       builder: (_) => Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.info_outline, color: Colors.grey.shade500, size: 50),
//             const SizedBox(height: 10),
//             const Text("Tidak ada data absensi maupun pengumuman",
//                 style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
//             Text(DateFormat("d MMMM yyyy", "id_ID").format(tanggal)),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatDate(String dateStr) {
//     try {
//       final dt = DateTime.parse(dateStr);
//       return "${dt.day} ${_monthName(dt.month)} ${dt.year}";
//     } catch (e) {
//       return dateStr;
//     }
//   }

//   String _monthName(int month) {
//     const months = [
//       "",
//       "Januari",
//       "Februari",
//       "Maret",
//       "April",
//       "Mei",
//       "Juni",
//       "Juli",
//       "Agustus",
//       "September",
//       "Oktober",
//       "November",
//       "Desember"
//     ];
//     return months[month];
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (loading) {
//       return const Scaffold(
//           body: Center(child: CircularProgressIndicator()));
//     }

//     return Scaffold(
//       drawer: SidebarNavbar(idSertifikat: widget.idSertifikat),
//       appBar: AppBar(
//         title: const Text("Dashboard PKL"),
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFFAEE1F9), Color(0xFFB9E8C9)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       backgroundColor: const Color(0xFFF8FBFF),
//       body: RefreshIndicator(
//         onRefresh: _initData,
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           padding: const EdgeInsets.all(18),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Selamat datang, ${_profile?.namaLengkap?.split(' ').first ?? 'Mahasiswa'} 👋",
//                 style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87),
//               ),
//               const SizedBox(height: 4),
//               Text("Semangat menjalani hari PKL-mu!",
//                   style: TextStyle(color: Colors.grey.shade600)),
//               const SizedBox(height: 20),

//               Card(
//                 elevation: 3,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: Colors.blue.shade200,
//                     child: const Icon(Icons.person, color: Colors.white),
//                   ),
//                   title: Text(_profile?.namaLengkap ?? "-",
//                       style: const TextStyle(fontWeight: FontWeight.bold)),
//                   subtitle: Text(
//                       "${_profile?.asalSekolah ?? '-'} • ${_profile?.jurusan ?? '-'}"),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // 🔹 Kalender
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.shade300,
//                       blurRadius: 6,
//                       offset: const Offset(0, 3),
//                     )
//                   ],
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: TableCalendar(
//                     focusedDay: focusedDay,
//                     firstDay: DateTime.utc(2024, 1, 1),
//                     lastDay: DateTime.utc(2026, 12, 31),
//                     selectedDayPredicate: (day) => isSameDay(selectedDay, day),
//                     eventLoader: (day) {
//                       final key = _normalizeDate(day);
//                       final events = <String>[];
//                       if (statusAbsensi.containsKey(key)) {
//                         events.add(statusAbsensi[key]!);
//                       }
//                       if (statusAnnouncement[key] == true) {
//                         events.add("Pengumuman");
//                       }
//                       return events;
//                     },
//                     onDaySelected: (selected, focused) {
//                       setState(() {
//                         selectedDay = selected;
//                         focusedDay = focused;
//                       });
//                       _showRiwayatGabunganBottomSheet(selected);
//                     },
//                     calendarStyle: CalendarStyle(
//                       todayDecoration: BoxDecoration(
//                           color: Colors.blue.shade200, shape: BoxShape.circle),
//                       selectedDecoration: BoxDecoration(
//                           color: Colors.green.shade300, shape: BoxShape.circle),
//                       markerDecoration: const BoxDecoration(
//                         color: Colors.transparent,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     calendarBuilders: CalendarBuilders(
//                       markerBuilder: (context, date, dayEvents) {
//                         if (dayEvents.isEmpty) return null;

//                         List<Widget> markers = [];

//                         if (dayEvents.contains("Pengumuman")) {
//                           markers.add(Positioned(
//                             top: 4,
//                             child: Container(
//                               width: 6,
//                               height: 6,
//                               decoration: BoxDecoration(
//                                 color: Colors.blue,
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                           ));
//                         }

//                         final absensiEvent = dayEvents.firstWhere(
//                           (e) =>
//                               e == "Hadir" ||
//                               e == "Izin" ||
//                               e == "Terlambat",
//                           orElse: () => "",
//                         );

//                         if (absensiEvent != "") {
//                           Color color;
//                           if (absensiEvent == "Hadir") color = Colors.green;
//                           else if (absensiEvent == "Izin") color = Colors.orange;
//                           else color = Colors.redAccent;

//                           markers.add(Positioned(
//                             bottom: 4,
//                             child: Container(
//                               width: 8,
//                               height: 8,
//                               decoration: BoxDecoration(
//                                 color: color,
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                           ));
//                         }

//                         return Stack(
//                           alignment: Alignment.center,
//                           children: markers,
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 24),

//               const Text("📊 Statistik Absensi",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               GridView.count(
//                 crossAxisCount: 3,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//                 children: [
//                   _buildStatCard("Hadir", statistik["Hadir"] ?? 0,
//                       Colors.green, Icons.check_circle),
//                   _buildStatCard("Izin", statistik["Izin"] ?? 0,
//                       Colors.orange, Icons.info_outline),
//                   _buildStatCard("Terlambat", statistik["Terlambat"] ?? 0,
//                       Colors.redAccent, Icons.timer),
//                 ],
//               ),

//               const SizedBox(height: 24),

//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text("📢 Pengumuman Terbaru",
//                       style:
//                           TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const AnnouncementPage()),
//                       );
//                     },
//                     child: const Text("Lihat Semua"),
//                   ),
//                 ],
//               ),
//               ...pengumuman.map(
//                 (a) => Card(
//                   elevation: 2,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16)),
//                   child: ListTile(
//                     title: Text(a.title ?? "-"),
//                     subtitle: Text(_formatDate(a.createdAt)),
//                     leading: const Icon(Icons.campaign, color: Colors.blue),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatCard(
//       String title, int count, Color color, IconData iconData) {
//     return Container(
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(iconData, color: color, size: 30),
//           const SizedBox(height: 8),
//           Text("$count",
//               style:
//                   TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
//           const SizedBox(height: 4),
//           Text(title, style: TextStyle(color: color)),
//         ],
//       ),
//     );
//   }
// }

// ——————————————
// FULL CODE (DENGAN LEGEND)
// ——————————————

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../widgets/sidebar_navbar.dart';
import '../pages/announcement_page.dart';
import '../models/announcement_model.dart';
import '../models/profile_model.dart';
import '../models/attendance_model.dart';
import '../services/announcement_service.dart';
import '../services/profile_service.dart';
import '../services/attendance_service.dart';

class DashboardPage extends StatefulWidget {
  final int idSertifikat;
  const DashboardPage({super.key, required this.idSertifikat});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  final ProfileService _profileService = ProfileService();
  final AttendanceService _attendanceService = AttendanceService();
  ProfileModel? _profile;
  List<Announcement> pengumuman = [];
  List<AttendanceModel> riwayatAbsensi = [];
  bool loading = true;

  Map<DateTime, bool> statusAnnouncement = {};

  DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  @override
  void initState() {
    super.initState();
    
    checkIzinStatus();
    initializeDateFormatting('id_ID', null).then((_) => _initData());
  }

  Future<void> _initData() async {
    await Future.wait([
      _loadProfile(),
      _loadPengumuman(),
      _loadAttendance(),
    ]);

    statusAnnouncement.clear();
    for (var a in pengumuman) {
      try {
        final key = _normalizeDate(DateTime.parse(a.createdAt));
        statusAnnouncement[key] = true;
      } catch (_) {}
    }

    setState(() => loading = false);
  }

  Future<void> _loadProfile() async {
    try {
      _profile = await _profileService.getProfile();
    } catch (e) {
      debugPrint("❌ Gagal memuat profil: $e");
    }
  }

  Future<void> _loadPengumuman() async {
    try {
      final data = await AnnouncementService.getAnnouncements();
      pengumuman = data.take(3).toList();

      for (var a in pengumuman) {
        final parsed = DateTime.tryParse(a.createdAt);
        if (parsed != null) {
          final normalized = _normalizeDate(parsed);
          debugPrint("Tanggal pengumuman: ${normalized.toIso8601String()}");
        }
      }
    } catch (e) {
      debugPrint("❌ Gagal memuat pengumuman: $e");
    }
  }

  Future<void> _loadAttendance() async {
    try {
      riwayatAbsensi =
          await _attendanceService.getAttendances(widget.idSertifikat);

      for (var absen in riwayatAbsensi) {
        final normalized = _normalizeDate(absen.tanggal);
        debugPrint("Tanggal absensi: ${normalized.toIso8601String()}");
      }
    } catch (e) {
      debugPrint("❌ Gagal memuat absensi: $e");
    }
  }

  Map<DateTime, String> get statusAbsensi {
    final map = <DateTime, String>{};
    for (var absen in riwayatAbsensi) {
      final key = _normalizeDate(absen.tanggal);
      map[key] = absen.status;
    }
    return map;
  }

  Map<String, int> get statistik {
    int hadir = 0, izin = 0, terlambat = 0;
    for (final a in riwayatAbsensi) {
      if (a.status == "Hadir")
        hadir++;
      else if (a.status == "Izin")
        izin++;
      else if (a.status == "Terlambat") terlambat++;
    }
    return {"Hadir": hadir, "Izin": izin, "Terlambat": terlambat};
  }

  // ————————————————————————————————
  // BOTTOM SHEET TETAP SAMA (TIDAK DIUBAH)
  // ————————————————————————————————
  void _showRiwayatGabunganBottomSheet(DateTime tanggal) {
    final tanggalNormal = _normalizeDate(tanggal);

    final status = statusAbsensi[tanggalNormal];

    final listPengumuman = pengumuman.where((a) {
      try {
        final createdAt = _normalizeDate(DateTime.parse(a.createdAt));
        return createdAt == tanggalNormal;
      } catch (_) {
        return false;
      }
    }).toList();

    if (status == null && listPengumuman.isEmpty) {
      _showNoDataBottomSheet(tanggal);
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 15),
              if (status != null) ...[
                const Text("Riwayat Absensi",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: status == "Hadir"
                        ? const Color(0xFFD7F5E8)
                        : status == "Izin"
                            ? const Color(0xFFFFF4E6)
                            : const Color(0xFFFFE3E6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: status == "Hadir"
                          ? Colors.green
                          : status == "Izin"
                              ? Colors.orange
                              : Colors.redAccent,
                      child: Icon(
                        status == "Hadir"
                            ? Icons.check_circle
                            : status == "Izin"
                                ? Icons.info_outline
                                : Icons.timer,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      status,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: status == "Hadir"
                            ? Colors.green
                            : status == "Izin"
                                ? Colors.orange
                                : Colors.redAccent,
                      ),
                    ),
                    subtitle: Text(
                      "Tanggal: ${DateFormat('d MMMM yyyy', 'id_ID').format(tanggal)}",
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              if (listPengumuman.isNotEmpty) ...[
                const Text("Riwayat Pengumuman",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 10),
                ...listPengumuman.map(
                  (a) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.teal.shade50],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade300,
                        child: const Icon(Icons.campaign, color: Colors.white),
                      ),
                      title: Text(a.title ?? "-",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.content ?? "",
                                style: const TextStyle(color: Colors.black87)),
                            const SizedBox(height: 4),
                            Text(
                              _formatDate(a.createdAt),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black38,
                                  fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showNoDataBottomSheet(DateTime tanggal) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline, color: Colors.grey.shade500, size: 50),
            const SizedBox(height: 10),
            const Text("Tidak ada data absensi maupun pengumuman",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
            Text(DateFormat("d MMMM yyyy", "id_ID").format(tanggal)),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return "${dt.day} ${_monthName(dt.month)} ${dt.year}";
    } catch (e) {
      return dateStr;
    }
  }

  String _monthName(int month) {
    const months = [
      "",
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];
    return months[month];
  }

  void checkIzinStatus() async {
    final attendanceService = AttendanceService();
    final data = await attendanceService.getAttendances(widget.idSertifikat);

    if (data.isEmpty) return;

    final last = data.last;

    if (last.status.toLowerCase() == "izin") {
      if (last.approvedStatus == "approved") {
        Future.microtask(() {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Izin Disetujui"),
              content: Text("Pengajuan izinmu sudah di-approve oleh mentor."),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          );
        });
      }

      if (last.approvedStatus == "rejected") {
        Future.microtask(() {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Izin Ditolak"),
              content: Text("Pengajuan izinmu ditolak mentor."),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      drawer: SidebarNavbar(idSertifikat: widget.idSertifikat),
      appBar: AppBar(
        title: const Text("Dashboard PKL"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFAEE1F9), Color(0xFFB9E8C9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF8FBFF),
      body: RefreshIndicator(
        onRefresh: _initData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Selamat datang, ${_profile?.namaLengkap?.split(' ').first ?? 'Mahasiswa'} 👋",
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text("Semangat menjalani hari PKL-mu!",
                  style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 20),

              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade200,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(_profile?.namaLengkap ?? "-",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      "${_profile?.asalSekolah ?? '-'} • ${_profile?.jurusan ?? '-'}"),
                ),
              ),
              const SizedBox(height: 20),

              // ————————————————————
              // KALENDER (TETAP SAMA)
              // ————————————————————
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: TableCalendar(
                    focusedDay: focusedDay,
                    firstDay: DateTime.utc(2024, 1, 1),
                    lastDay: DateTime.utc(2026, 12, 31),
                    selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                    eventLoader: (day) {
                      final key = _normalizeDate(day);
                      final events = <String>[];
                      if (statusAbsensi.containsKey(key)) {
                        events.add(statusAbsensi[key]!);
                      }
                      if (statusAnnouncement[key] == true) {
                        events.add("Pengumuman");
                      }
                      return events;
                    },
                    onDaySelected: (selected, focused) {
                      setState(() {
                        selectedDay = selected;
                        focusedDay = focused;
                      });
                      _showRiwayatGabunganBottomSheet(selected);
                    },
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                          color: Colors.blue.shade200, shape: BoxShape.circle),
                      selectedDecoration: BoxDecoration(
                          color: Colors.green.shade300, shape: BoxShape.circle),
                      markerDecoration: const BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, dayEvents) {
                        if (dayEvents.isEmpty) return null;

                        List<Widget> markers = [];

                        if (dayEvents.contains("Pengumuman")) {
                          markers.add(Positioned(
                            top: 4,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ));
                        }

                        final absensiEvent = dayEvents.firstWhere(
                          (e) =>
                              e == "Hadir" || e == "Izin" || e == "Terlambat",
                          orElse: () => "",
                        );

                        if (absensiEvent != "") {
                          Color color;
                          if (absensiEvent == "Hadir")
                            color = Colors.green;
                          else if (absensiEvent == "Izin")
                            color = Colors.orange;
                          else
                            color = Colors.redAccent;

                          markers.add(Positioned(
                            bottom: 4,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ));
                        }

                        return Stack(
                          alignment: Alignment.center,
                          children: markers,
                        );
                      },
                    ),
                  ),
                ),
              ),

              // ————————————————————
              // 🔥 LEGEND WARNA KALENDER 🔥
              // ————————————————————
              const SizedBox(height: 16),
              _wrapLegend(),

              const SizedBox(height: 24),

              const Text("📊 Statistik Absensi",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildStatCard("Hadir", statistik["Hadir"] ?? 0, Colors.green,
                      Icons.check_circle),
                  _buildStatCard("Izin", statistik["Izin"] ?? 0, Colors.orange,
                      Icons.info_outline),
                  _buildStatCard("Terlambat", statistik["Terlambat"] ?? 0,
                      Colors.redAccent, Icons.timer),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("📢 Pengumuman Terbaru",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AnnouncementPage()),
                      );
                    },
                    child: const Text("Lihat Semua"),
                  ),
                ],
              ),
              ...pengumuman.map(
                (a) => Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    title: Text(a.title ?? "-"),
                    subtitle: Text(_formatDate(a.createdAt)),
                    leading: const Icon(Icons.campaign, color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ————————————————————————————————
  // 🔥 LEGEND WARNA KALENDER (TAMBAHAN)
  // ————————————————————————————————
  Widget _wrapLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 10,
      children: [
        _legendItem(Colors.blue, "Pengumuman"),
        _legendItem(Colors.green, "Hadir"),
        _legendItem(Colors.orange, "Izin"),
        _legendItem(Colors.redAccent, "Terlambat"),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildStatCard(
      String title, int count, Color color, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, color: color, size: 30),
          const SizedBox(height: 8),
          Text("$count",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
Widget _legendItem(Color color, String text) {
  return Row(
    children: [
      Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 6),
      Text(
        text,
        style: const TextStyle(fontSize: 12),
      ),
    ],
  );
}
Widget _buildStatCard(String title, String value, Color color) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.4)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: color.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    ),
  );
}

