import 'package:flutter/material.dart';
import 'dashboard_page.dart';

class HomePage extends StatelessWidget {
  final int idSertifikat;
  const HomePage({super.key, required this.idSertifikat});

  @override
  Widget build(BuildContext context) {
    return DashboardPage(idSertifikat: idSertifikat);
  }
}


// import 'package:flutter/material.dart';
// import 'package:simagang_app/routes.dart';
// import 'announcement_page.dart';
// import 'profile_page.dart';
// import 'attendance_page.dart';
// import '../utils/session_manager.dart';
// import 'login_page.dart';

// class HomePage extends StatelessWidget {
//   final int idSertifikat;
//   const HomePage({super.key, required this.idSertifikat});

//   void _logout(BuildContext context) async {
//     await SessionManager.clearSession();
//     if (context.mounted) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const LoginPage()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Dashboard PKL"),
//         actions: [
//           IconButton(
//             onPressed: () => _logout(context),
//             icon: const Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: ListView(
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text(
//               "Selamat datang di aplikasi PKL 👋",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//           ),
//           ListTile(
//           title: const Text("📢 Pengumuman"),
//           onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//           builder: (_) => const AnnouncementPage(),
//            ),
//           ),
//         ),
//           ListTile(
//             title: const Text("👤 Profil"),
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => ProfilePage(),
//               ),
//             ),
//           ),
//           ListTile(
//             title: const Text("📝 Absensi"),
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => AttendancePage(idSertifikat: idSertifikat),
//               ),
//             ),
//           ),
//           ListTile(
//             title: const Text("🗒️ Izin"),
//             onTap: () => Navigator.pushNamed(context, Routes.izin),
//           ),
//         ],
//       ),
//     );
//   }
// }
