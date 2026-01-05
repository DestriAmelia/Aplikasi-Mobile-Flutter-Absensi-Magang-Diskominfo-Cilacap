import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../services/profile_service.dart';
import 'edit_profile_page.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<ProfileModel> _futureProfile;
  final ProfileService _profileService = ProfileService();

  @override
  void initState() {
    super.initState();
    _futureProfile = _profileService.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("👤 Profil Mahasiswa"),
        backgroundColor: Colors.blue.shade400,
        elevation: 2,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<ProfileModel>(
        future: _futureProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Terjadi kesalahan:\n${snapshot.error}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Data profil tidak ditemukan."));
          }

          final profile = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                // 🧑‍🎓 Header Profil dengan gradient pastel
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade300,
                        Colors.purple.shade100,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade100.withOpacity(0.5),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.blue.shade400,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        profile.namaLengkap ?? '-',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        profile.asalSekolah ?? '-',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          profile.jurusan ?? '-',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                _buildSection("Informasi Pribadi", [
                  _infoItem("ID Sertifikat", profile.idSertifikat.toString()),
                  _infoItem("NIM / NIS", profile.nimNis),
                  _infoItem("Tempat Lahir", profile.tempatLahir),
                  _infoItem("Tanggal Lahir", formatDate(profile.tglLahir)),
                ]),

                _buildDivider(),

                _buildSection("Informasi PKL", [
                  _infoItem("Bidang Magang", profile.bidang),
                  _infoItem("Tanggal Mulai", formatDate(profile.tglMulai)),
                  _infoItem("Tanggal Selesai", formatDate(profile.tglSelesai)),
                  _infoItem(
                      "Tanggal Sertifikat", formatDate(profile.tglSertifikat)),
                ]),

                _buildDivider(),

                _buildSection("Pembimbing", [
                  _infoItem("Nama Pembimbing", profile.nmPembimbing),
                  _infoItem("Jabatan Pembimbing", profile.jabatanPembimbing),
                ]),

                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FutureBuilder<ProfileModel>(
        future: _futureProfile,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          return FloatingActionButton.extended(
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfilePage(profile: snapshot.data!),
                ),
              );
              if (updated == true) {
                setState(() {
                  _futureProfile = _profileService.getProfile();
                });
              }
            },
            label: const Text("Edit Profil"),
            icon: const Icon(Icons.edit),
            backgroundColor: Colors.blue.shade400,
          );
        },
      ),
    );
  }

  // 🔹 Section builder (card cantik)
  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _infoItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value ?? '-',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Divider(color: Colors.grey.shade300, thickness: 1),
      );

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
