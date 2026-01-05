// import 'package:flutter/material.dart';
// import '../models/announcement_model.dart';

// class AnnouncementCard extends StatelessWidget {
//   final Announcement announcement;

//   const AnnouncementCard({super.key, required this.announcement});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       child: ListTile(
//         title: Text(
//           announcement.title,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(
//           announcement.content,
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//         ),
//         trailing: Text(
//           announcement.createdAt.split("T").first, // tampilkan tanggal doang
//           style: const TextStyle(fontSize: 12, color: Colors.grey),
//         ),
//         onTap: () {
//           // opsional: detail page
//           showDialog(
//             context: context,
//             builder: (_) => AlertDialog(
//               title: Text(announcement.title),
//               content: Text(announcement.content),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text("Tutup"),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
