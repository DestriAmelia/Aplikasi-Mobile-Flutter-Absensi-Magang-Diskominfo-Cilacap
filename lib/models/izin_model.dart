class IzinModel {
  final int id;
  final int idSertifikat;
  final String tanggal;
  final String alasan;
  final String status;

  IzinModel({
    required this.id,
    required this.idSertifikat,
    required this.tanggal,
    required this.alasan,
    required this.status,
  });

  factory IzinModel.fromJson(Map<String, dynamic> json) {
    return IzinModel(
      id: json['id'] ?? 0,
      idSertifikat: json['id_sertifikat'] ?? 0,
      tanggal: json['tanggal'] ?? '',
      alasan: json['alasan'] ?? '',   // 🔑 ini harus sesuai field Laravel
      status: json['status'] ?? '',
    );
  }
}
