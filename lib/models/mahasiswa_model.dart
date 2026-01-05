class Mahasiswa {
  final int id;
  final int userId;
  final String nama;
  final String nim;
  final String jurusan;
  final String angkatan;
  final String? email;
  final String? noHp;

  Mahasiswa({
    required this.id,
    required this.userId,
    required this.nama,
    required this.nim,
    required this.jurusan,
    required this.angkatan,
    this.email,
    this.noHp,
  });

  // ✅ Convert JSON → Mahasiswa
  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    return Mahasiswa(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0, // <-- pakai snake_case
      nama: json['nama'] ?? '',
      nim: json['nim'] ?? '',
      jurusan: json['jurusan'] ?? '',
      angkatan: json['angkatan'] ?? '',
      email: json['email'],
      noHp: json['no_hp'], // <-- snake_case
    );
  }

  // ✅ Convert Mahasiswa → JSON (buat update ke backend)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId, // <-- backend pakai snake_case
      "nama": nama,
      "nim": nim,
      "jurusan": jurusan,
      "angkatan": angkatan,
      "email": email,
      "no_hp": noHp,
    };
  }
}
