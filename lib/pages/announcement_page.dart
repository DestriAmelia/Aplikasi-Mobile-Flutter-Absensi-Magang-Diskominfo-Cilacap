
import 'package:flutter/material.dart';
import '../models/announcement_model.dart';
import '../services/announcement_service.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  late Future<List<Announcement>> _futureAnnouncements;

  @override
  void initState() {
    super.initState();
    _futureAnnouncements = AnnouncementService.getAnnouncements();
  }

  // Fungsi untuk format tanggal
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
      "", "Januari", "Februari", "Maret", "April", "Mei", "Juni",
      "Juli", "Agustus", "September", "Oktober", "November", "Desember"
    ];
    return months[month];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "📢 Pengumuman",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
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
      body: FutureBuilder<List<Announcement>>(
        future: _futureAnnouncements,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.blue.shade300,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Memuat pengumuman...",
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Terjadi kesalahan: ${snapshot.error}",
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.announcement_outlined,
                    color: Colors.grey.shade400, size: 60),
                const SizedBox(height: 10),
                const Text(
                  "Belum ada pengumuman",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final a = data[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade50,
                      Colors.teal.shade50,
                    ],
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
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade200,
                    child: const Icon(Icons.campaign, color: Colors.white),
                  ),
                  title: Text(
                    a.title ?? "Tanpa Judul",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.content ?? "",
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(a.createdAt),
                          style: const TextStyle(
                            color: Colors.black38,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


