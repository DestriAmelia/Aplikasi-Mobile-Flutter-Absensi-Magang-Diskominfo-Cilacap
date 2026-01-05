class Announcement {
  final int id;
  final String title;
  final String content;
  final String createdAt;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'] ?? "",
      content: json['content'] ?? "",
      createdAt: json['created_at'] ?? "",
    );
  }
}
