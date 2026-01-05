import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../services/profile_service.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileModel profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final ProfileService _profileService = ProfileService();

  late TextEditingController _namaController;
  late TextEditingController _asalSekolahController;
  late TextEditingController _nimController;
  late TextEditingController _jurusanController;
  late TextEditingController _bidangController;
  late TextEditingController _tempatLahirController;
  late TextEditingController _tglLahirController;
  late TextEditingController _nmPembimbingController;
  late TextEditingController _jabatanPembimbingController;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.profile.namaLengkap);
    _asalSekolahController = TextEditingController(text: widget.profile.asalSekolah);
    _nimController = TextEditingController(text: widget.profile.nimNis);
    _jurusanController = TextEditingController(text: widget.profile.jurusan);
    _bidangController = TextEditingController(text: widget.profile.bidang);
    _tempatLahirController = TextEditingController(text: widget.profile.tempatLahir);
    _tglLahirController =
        TextEditingController(text: widget.profile.tglLahir?.split("T")[0] ?? "");
    _nmPembimbingController = TextEditingController(text: widget.profile.nmPembimbing);
    _jabatanPembimbingController =
        TextEditingController(text: widget.profile.jabatanPembimbing);
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final updatedProfile = ProfileModel(
      idSertifikat: widget.profile.idSertifikat,
      namaLengkap: _namaController.text,
      asalSekolah: _asalSekolahController.text,
      nimNis: _nimController.text,
      jurusan: _jurusanController.text,
      bidang: _bidangController.text,
      tempatLahir: _tempatLahirController.text,
      tglLahir: _tglLahirController.text,
      tglMulai: widget.profile.tglMulai,
      tglSelesai: widget.profile.tglSelesai,
      tglSertifikat: widget.profile.tglSertifikat,
      nmPembimbing: _nmPembimbingController.text,
      jabatanPembimbing: _jabatanPembimbingController.text,
    );

    final success = await _profileService.updateProfile(updatedProfile);
    setState(() => _loading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Profil berhasil diperbarui")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Gagal memperbarui profil")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Edit Profil Mahasiswa",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🌈 Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade200, Colors.teal.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 60, color: Colors.blue.shade400),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Perbarui Data Profil",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ✨ Card Form
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(Icons.person, "Nama Lengkap", _namaController),
                    _buildTextField(Icons.badge, "NIM / NIS", _nimController),
                    _buildTextField(Icons.school, "Asal Sekolah", _asalSekolahController),
                    _buildTextField(Icons.book, "Jurusan", _jurusanController),
                    _buildTextField(Icons.business_center, "Bidang Magang", _bidangController),
                    _buildTextField(Icons.place, "Tempat Lahir", _tempatLahirController),
                    _buildTextField(
                        Icons.date_range, "Tanggal Lahir (YYYY-MM-DD)", _tglLahirController),
                    _buildTextField(
                        Icons.supervised_user_circle, "Nama Pembimbing", _nmPembimbingController),
                    _buildTextField(
                        Icons.work_outline, "Jabatan Pembimbing", _jabatanPembimbingController),
                    const SizedBox(height: 25),
                    _loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton.icon(
                            icon: const Icon(Icons.save_rounded),
                            label: const Text(
                              "Simpan Perubahan",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade400,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              shadowColor:
                                  Colors.blueAccent.withOpacity(0.3),
                              elevation: 4,
                            ),
                            onPressed: _updateProfile,
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      IconData icon, String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue.shade400),
          labelText: label,
          floatingLabelStyle: TextStyle(
            color: Colors.blue.shade700,
            fontWeight: FontWeight.bold,
          ),
          filled: true,
          fillColor: Colors.blue.shade50.withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        ),
        validator: (v) => (v == null || v.isEmpty) ? "Tidak boleh kosong" : null,
      ),
    );
  }
}
