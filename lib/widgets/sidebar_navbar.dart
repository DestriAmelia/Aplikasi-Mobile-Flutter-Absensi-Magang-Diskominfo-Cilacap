// import 'package:flutter/material.dart';
// import '../utils/session_manager.dart';
// import '../pages/login_page.dart';
// import '../pages/home_page.dart';
// import '../pages/attendance_page.dart';
// import '../pages/announcement_page.dart';
// import '../pages/profile_page.dart';

// class SidebarNavbar extends StatelessWidget {
//   final int idSertifikat;
//   const SidebarNavbar({super.key, required this.idSertifikat});

//   void _logout(BuildContext context) async {
//     await SessionManager.clearSession();
//     if (context.mounted) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => const LoginPage()),
//         (route) => false,
//       );
//     }
//   }

//   Widget _buildMenuItem({
//     required BuildContext context,
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//     Color? color,
//   }) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(12),
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         child: Row(
//           children: [
//             Icon(icon, color: color ?? Colors.blueGrey.shade700, size: 22),
//             const SizedBox(width: 12),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 15,
//                 color: Colors.blueGrey.shade800,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final pastelBlue = const Color(0xFFE3F2FD);
//     final pastelGradient = const LinearGradient(
//       colors: [Color(0xFF90CAF9), Color(0xFF64B5F6)],
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//     );

//     return Drawer(
//       backgroundColor: pastelBlue,
//       child: Column(
//         children: [
//           // 🔹 HEADER PROFILE AREA
//           Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               gradient: pastelGradient,
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(24),
//                 bottomRight: Radius.circular(24),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.blue.shade200.withOpacity(0.5),
//                   blurRadius: 8,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             padding: const EdgeInsets.only(top: 40, bottom: 24),
//             child: Column(
//               children: [
//                 const CircleAvatar(
//                   radius: 34,
//                   backgroundColor: Colors.white,
//                   child: Icon(Icons.person, color: Color(0xFF42A5F5), size: 36),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   "SIMA-GANG",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                     letterSpacing: 0.8,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 16),

//           // 🔹 MENU ITEMS
//           Expanded(
//             child: ListView(
//               children: [
//                 _buildMenuItem(
//                   context: context,
//                   icon: Icons.dashboard_rounded,
//                   label: "Dashboard",
//                   onTap: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => HomePage(idSertifikat: idSertifikat),
//                       ),
//                     );
//                   },
//                 ),
//                 _buildMenuItem(
//                   context: context,
//                   icon: Icons.edit_calendar_rounded,
//                   label: "Absensi",
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) =>
//                             AttendancePage(idSertifikat: idSertifikat),
//                       ),
//                     );
//                   },
//                 ),
//                 _buildMenuItem(
//                   context: context,
//                   icon: Icons.campaign_rounded,
//                   label: "Pengumuman",
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const AnnouncementPage(),
//                       ),
//                     );
//                   },
//                 ),
//                 _buildMenuItem(
//                   context: context,
//                   icon: Icons.account_circle_rounded,
//                   label: "Profil",
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const ProfilePage(),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),

//           // 🔹 Divider lembut
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             height: 1,
//             color: Colors.blueGrey.shade100,
//           ),

//           // 🔹 Logout Button
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 elevation: 0,
//                 backgroundColor: Colors.red.shade100,
//                 foregroundColor: Colors.red.shade700,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//               ),
//               icon: const Icon(Icons.logout_rounded),
//               label: const Text(
//                 "Keluar",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               onPressed: () => _logout(context),
//             ),
//           ),
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/session_manager.dart';
import '../pages/login_page.dart';
import '../pages/home_page.dart';
import '../pages/attendance_page.dart';
import '../pages/announcement_page.dart';
import '../pages/profile_page.dart';

class SidebarNavbar extends StatelessWidget {
  final int idSertifikat;
  const SidebarNavbar({super.key, required this.idSertifikat});

  void _logout(BuildContext context) async {
    await SessionManager.clearSession();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      splashColor: Colors.blueAccent.withOpacity(0.1),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: Colors.blueGrey.shade800,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pastelGradient = const LinearGradient(
      colors: [Color(0xFF90CAF9), Color(0xFF42A5F5)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Drawer(
      elevation: 8,
      backgroundColor: Colors.white.withOpacity(0.9),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        child: Stack(
          children: [
            // 🔹 Background blur + gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade50,
                    Colors.blue.shade100.withOpacity(0.7),
                    Colors.white,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(color: Colors.white.withOpacity(0.1)),
            ),

            // 🔹 Main content
            Column(
              children: [
                // HEADER
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: pastelGradient,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(top: 60, bottom: 28),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person_rounded,
                              color: Color(0xFF1976D2), size: 40),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "SIMA-GANG",
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Sistem Magang Terpadu",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.9),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // MENU ITEMS
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 4),
                    children: [
                      _buildMenuItem(
                        context: context,
                        icon: Icons.dashboard_rounded,
                        label: "Dashboard",
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  HomePage(idSertifikat: idSertifikat),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        context: context,
                        icon: Icons.edit_calendar_rounded,
                        label: "Absensi",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AttendancePage(idSertifikat: idSertifikat),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        context: context,
                        icon: Icons.campaign_rounded,
                        label: "Pengumuman",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AnnouncementPage(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        context: context,
                        icon: Icons.account_circle_rounded,
                        label: "Profil",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfilePage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Divider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    color: Colors.blueGrey.shade200,
                    thickness: 1,
                  ),
                ),

                // LOGOUT BUTTON
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 14.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 13, horizontal: 20),
                    ),
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text(
                      "Keluar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    onPressed: () => _logout(context),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
