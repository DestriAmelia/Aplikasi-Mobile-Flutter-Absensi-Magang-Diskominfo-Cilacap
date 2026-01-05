import 'package:flutter/material.dart';
import '../services/attendance_service.dart';
import '../models/attendance_model.dart';

class AttendancePage extends StatefulWidget {
  final int idSertifikat;
  const AttendancePage({super.key, required this.idSertifikat});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {


  final AttendanceService _attendanceService = AttendanceService();
  String? todayStatus;
  List<AttendanceModel> riwayatAbsensi = [];
  bool loading = true;
  bool isSubmitting = false;

  final TextEditingController notesController = TextEditingController();
  final TextEditingController locationController =
      TextEditingController(text: "Kantor Diskominfo");
  String selectedStatus = "Hadir";

  @override
  void initState() {
    super.initState();
    _loadAbsensi();
  }

  Future<void> _loadAbsensi() async {
    setState(() => loading = true);
    try {
      final history = await _attendanceService.getAttendances(widget.idSertifikat);

      // 🔹 cari absensi hari ini dari riwayat
      final today = DateTime.now();
      final todayNormalized = DateTime(today.year, today.month, today.day);

      AttendanceModel? todayRecord;
      for (var a in history) {
        final absenDate = DateTime(a.tanggal.year, a.tanggal.month, a.tanggal.day);
        if (absenDate == todayNormalized) {
          todayRecord = a;
          break;
        }
      }

      setState(() {
        todayStatus = todayRecord?.status; // null jika belum absen
        riwayatAbsensi = history;
        // sort terbaru di atas
        riwayatAbsensi.sort((a, b) => b.tanggal.compareTo(a.tanggal));
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat absensi: $e")),
      );
    }
  }

  Future<void> submitAttendance() async {
    if (isSubmitting) return; // cegah double submit
    setState(() => isSubmitting = true);

    bool success = false;
    try {
      if (selectedStatus == 'Hadir') {
        success = await _attendanceService.absenHadir(
          widget.idSertifikat,
          location: locationController.text,
          notes: notesController.text,
        );
      } else if (selectedStatus == 'Izin') {
        success = await _attendanceService.absenIzin(
          widget.idSertifikat,
          notesController.text,
        );
      } else if (selectedStatus == 'Terlambat') {
        success = await _attendanceService.absenHadir(
          widget.idSertifikat,
          location: locationController.text,
          notes: "Terlambat: ${notesController.text}",
        );
      }

      if (success) {
        notesController.clear();
        // refresh riwayat absensi dan status hari ini
        await _loadAbsensi();

        // 🔔 TAMPILKAN POPUP DI SINI
      showSuccessPopup(selectedStatus);
      
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Presensi $selectedStatus berhasil")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Gagal presensi $selectedStatus")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Terjadi kesalahan: $e")),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  // 🌈 Warna status pastel
  Color getStatusColor(String? status) {
    switch (status) {
      case "Hadir":
        return const Color(0xFFD7F5E8); // soft green
      case "Izin":
        return const Color(0xFFFFF4E6); // soft orange
      case "Terlambat":
        return const Color(0xFFFFE3E6); // soft pink-red
      default:
        return const Color(0xFFF0F0F0); // gray
    }
  }

  Color getStatusAccent(String? status) {
    switch (status) {
      case "Hadir":
        return Colors.green;
      case "Izin":
        return Colors.orange;
      case "Terlambat":
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String? status) {
    switch (status) {
      case "Hadir":
        return Icons.check_circle;
      case "Izin":
        return Icons.info_outline;
      case "Terlambat":
        return Icons.timer;
      default:
        return Icons.help_outline;
    }
  }

  String formatDate(String? dateStr, [String? timeStr]) {
    if (dateStr == null || dateStr.isEmpty) return "-";
    return timeStr != null && timeStr.isNotEmpty
        ? "$dateStr • $timeStr"
        : dateStr;
  }

  // ← DI SINI kamu taruh fungsi popup
  void showSuccessPopup(String status) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB3E5FC), Color(0xFFB2DFDB)],
            ),
            borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle,
                    color: Colors.green, size: 48),
                SizedBox(height: 12),
                Text(
                  "Presensi $status Berhasil!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                )
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "🕒 Absensi Mahasiswa",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAbsensi,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 🌼 Status Hari Ini
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [getStatusColor(todayStatus), Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: getStatusAccent(todayStatus),
                          child: Icon(
                            getStatusIcon(todayStatus),
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Status Kehadiran Hari Ini",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              todayStatus ?? "-",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: getStatusAccent(todayStatus),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 🌸 Form Absensi
                  const Text(
                    "Form Absensi Hari Ini",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 16),

                  // 🌷 Dropdown cantik
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedStatus,
                          icon: const Icon(Icons.arrow_drop_down_rounded,
                              color: Colors.blueAccent),
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(
                              value: "Hadir",
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green),
                                  SizedBox(width: 10),
                                  Text("Hadir"),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: "Izin",
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline, color: Colors.orange),
                                  SizedBox(width: 10),
                                  Text("Izin"),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: "Terlambat",
                              child: Row(
                                children: [
                                  Icon(Icons.timer, color: Colors.redAccent),
                                  SizedBox(width: 10),
                                  Text("Terlambat"),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (val) =>
                              setState(() => selectedStatus = val!),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 🌿 Input lokasi & catatan
                  if (selectedStatus != "Izin")
                    _buildInputField(
                      controller: locationController,
                      icon: Icons.location_on_outlined,
                      hint: "Lokasi saat ini (opsional)",
                    ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    controller: notesController,
                    icon: Icons.note_alt_outlined,
                    hint: "Catatan tambahan (opsional)",
                    maxLines: 3,
                  ),

                  const SizedBox(height: 24),

                  // 🌈 Tombol kirim gradient
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 4,
                      ),
                            onPressed: isSubmitting
          ? null
          : () {
              if (todayStatus != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("❌ Anda sudah absen hari ini")),
                );
                return;
              }
              submitAttendance();
            },

                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF90CAF9), Color(0xFF64B5F6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                        ),
                        child: const Center(
                          child: Text(
                            "Kirim Absensi",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 📅 Riwayat Absensi
                  const Text(
                    "📅 Riwayat Absensi",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  if (riwayatAbsensi.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Belum ada riwayat absensi.",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                      ),
                    )
                  else
                    Column(
                      children: riwayatAbsensi.map((absen) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: getStatusColor(absen.status)
                                .withOpacity(0.6),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    getStatusAccent(absen.status),
                                child: Icon(
                                  getStatusIcon(absen.status),
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      absen.status ?? "-",
                                      style: TextStyle(
                                          color:
                                              getStatusAccent(absen.status),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      formatDate(absen.formattedDate, absen.time),
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black87),
                                    ),
                                    if (absen.location != null &&
                                        absen.location!.isNotEmpty)
                                      Text("📍 ${absen.location}",
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54)),
                                    if (absen.notes != null &&
                                        absen.notes!.isNotEmpty)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          "📝 ${absen.notes}",
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black87,
                                              fontStyle:
                                                  FontStyle.italic),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.lightBlueAccent),
          hintText: hint,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

