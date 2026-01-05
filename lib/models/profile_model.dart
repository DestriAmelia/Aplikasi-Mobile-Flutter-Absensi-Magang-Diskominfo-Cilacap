class ProfileModel {
  final int idSertifikat;
  final String namaLengkap;
  final String asalSekolah;
  final String nimNis;
  final String? jurusan;
  final String? bidang;
  final String? tempatLahir;
  final String? tglLahir;
  final String? tglMulai;
  final String? tglSelesai;
  final String? tglSertifikat;
  final String? nmPembimbing;
  final String? jabatanPembimbing;

  ProfileModel({
    required this.idSertifikat,
    required this.namaLengkap,
    required this.asalSekolah,
    required this.nimNis,
    this.jurusan,
    this.bidang,
    this.tempatLahir,
    this.tglLahir,
    this.tglMulai,
    this.tglSelesai,
    this.tglSertifikat,
    this.nmPembimbing,
    this.jabatanPembimbing,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      idSertifikat: (json['id_sertifikat'] ?? 0) as int,
      namaLengkap: json['nama_lengkap'],
      asalSekolah: json['asal_sekolah'],
      nimNis: json['nim_nis'],
      jurusan: json['jurusan'],
      bidang: json['bidang'],
      tempatLahir: json['tempat_lahir'],
      tglLahir: json['tgl_lahir'],
      tglMulai: json['tgl_mulai'],
      tglSelesai: json['tgl_selesai'],
      tglSertifikat: json['tgl_sertifikat'],
      nmPembimbing: json['nm_pembimbing'],
      jabatanPembimbing: json['jabatan_pembimbing'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_sertifikat': idSertifikat, // wajib dikirim
      'nama_lengkap': namaLengkap,
      'asal_sekolah': asalSekolah,
      'nim_nis': nimNis,
      'jurusan': jurusan,
      'bidang': bidang,
      'tempat_lahir': tempatLahir,
      'tgl_lahir': tglLahir?.split("T")[0], // kirim YYYY-MM-DD
      'nm_pembimbing': nmPembimbing,
      'jabatan_pembimbing': jabatanPembimbing,
    };
  }
}
