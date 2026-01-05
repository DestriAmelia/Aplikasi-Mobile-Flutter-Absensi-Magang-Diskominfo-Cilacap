class UserModel {
  final int id;
  final String username;
  final String role;
  final int? idSertifikat; // bisa null
  final String? token; // token login

  UserModel({
    required this.id,
    required this.username,
    required this.role,
    this.idSertifikat,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      username: json['username'] ?? '',
      role: json['role'] ?? '',
      idSertifikat: json['id_sertifikat'] is int
          ? json['id_sertifikat']
          : int.tryParse(json['id_sertifikat']?.toString() ?? ''),
      token: json['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'role': role,
      'id_sertifikat': idSertifikat,
      'token': token,
    };
  }
}
