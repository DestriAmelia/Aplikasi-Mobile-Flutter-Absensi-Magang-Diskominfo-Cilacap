// import 'package:flutter/material.dart';
// import '../services/auth_service.dart';
// import '../utils/session_manager.dart';
// import 'home_page.dart';
// import 'register_page.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _loading = false;

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _login() async {
//     if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Username dan Password harus diisi")),
//       );
//       return;
//     }

//     setState(() => _loading = true);
//     try {
//       final user = await AuthService()
//           .login(_usernameController.text.trim(), _passwordController.text.trim());

//       if (user.token != null && user.idSertifikat != null) {
//         await SessionManager.saveSession(user.token!, user.idSertifikat!);
//       }

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Login berhasil"),
//           backgroundColor: Colors.green,
//         ),
//       );

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => HomePage(idSertifikat: user.idSertifikat ?? 0)),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Login gagal: $e"), backgroundColor: Colors.red),
//       );
//     }
//     setState(() => _loading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final pastelBlue = Colors.blue.shade300;
//     final pastelTeal = Colors.teal.shade100;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F7FF),
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [pastelBlue.withOpacity(0.3), pastelTeal.withOpacity(0.3)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // 🌀 Icon Header
//                   Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: pastelBlue.withOpacity(0.3),
//                           blurRadius: 12,
//                           offset: const Offset(0, 6),
//                         ),
//                       ],
//                     ),
//                     child: CircleAvatar(
//                       radius: 45,
//                       backgroundColor: Colors.white,
//                       child: Icon(Icons.lock_rounded, size: 50, color: Colors.blue.shade400),
//                     ),
//                   ),

//                   const SizedBox(height: 25),

//                   // 🩵 Title
//                   Text(
//                     "Selamat Datang 👋",
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue.shade800,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   const Text(
//                     "Silakan masuk ke akun Anda",
//                     style: TextStyle(color: Colors.grey, fontSize: 15),
//                   ),
//                   const SizedBox(height: 25),

//                   // 🌸 Card Login
//                   Container(
//                     padding: const EdgeInsets.all(22),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(26),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.blueGrey.withOpacity(0.15),
//                           blurRadius: 12,
//                           offset: const Offset(0, 6),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         _buildTextField(
//                             controller: _usernameController,
//                             label: "Username",
//                             icon: Icons.person_outline),
//                         const SizedBox(height: 15),
//                         _buildTextField(
//                             controller: _passwordController,
//                             label: "Password",
//                             icon: Icons.lock_outline,
//                             obscure: true),
//                         const SizedBox(height: 22),

//                         // 🔹 Tombol Login
//                         _loading
//                             ? const CircularProgressIndicator()
//                             : ElevatedButton(
//                                 onPressed: _login,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.blue.shade400,
//                                   foregroundColor: Colors.white,
//                                   minimumSize: const Size.fromHeight(50),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(14),
//                                   ),
//                                   elevation: 4,
//                                   shadowColor: Colors.blueAccent.withOpacity(0.3),
//                                 ),
//                                 child: const Text(
//                                   "Masuk",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold, fontSize: 16),
//                                 ),
//                               ),
//                         const SizedBox(height: 14),

//                         // 🔸 Register Link
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Text(
//                               "Belum punya akun?",
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                             TextButton(
//                               onPressed: () => Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (_) => const RegisterPage()),
//                               ),
//                               child: Text(
//                                 "Daftar Sekarang",
//                                 style: TextStyle(
//                                   color: Colors.blue.shade600,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 40),

//                   // Footer kecil
//                   Text(
//                     "© 2025 Magang App | All rights reserved",
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     bool obscure = false,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: obscure,
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.blue.shade400),
//         labelText: label,
//         floatingLabelStyle: TextStyle(
//           color: Colors.blue.shade700,
//           fontWeight: FontWeight.bold,
//         ),
//         filled: true,
//         fillColor: Colors.blue.shade50.withOpacity(0.3),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
//         ),
//         contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/session_manager.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  // ======================================================
  // 🔍 Ekstraksi pesan error dari Exception (tanpa JSON)
  // ======================================================
  String extractErrorMessage(dynamic e) {
    try {
      final raw = e.toString();

      if (raw.contains("message")) {
        final start = raw.indexOf("message") + 10;
        final end = raw.indexOf("}", start);
        return raw.substring(start, end).replaceAll('"', '');
      }
      return raw;
    } catch (_) {
      return e.toString();
    }
  }

  // ======================================================
  // 🔔 CUSTOM SNACKBARS + ANIMASI
  // ======================================================
  void showAnimatedSnackBar(String message, Color color, {bool top = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 15)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1600),
        margin: top
            ? const EdgeInsets.only(top: 20, left: 20, right: 20)
            : const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        animation: CurvedAnimation(
          parent: kAlwaysCompleteAnimation,
          curve: Curves.easeOutBack,
        ),
      ),
    );
  }

  void showSuccess(String message) {
    showAnimatedSnackBar(message, Colors.green, top: true);
  }

  void showError(String message) {
    showAnimatedSnackBar(message, Colors.red);

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade400, size: 70),
              const SizedBox(height: 14),
              Text(
                "Login Gagal",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade600,
                ),
              ),
              const SizedBox(height: 10),
              Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text("OK"),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ======================================================
  // 🎉 SUCCESS DIALOG + AUTO CLOSE 2 DETIK + FIXED NAVIGATION
  // ======================================================
  Future<void> showSuccessDialogAutoClose(Function onClosed) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_rounded,
                  color: Colors.green.shade600, size: 72),
              const SizedBox(height: 12),
              const Text(
                "Login Berhasil!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Selamat datang kembali 👋",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) Navigator.pop(context);

    await Future.delayed(const Duration(milliseconds: 200));

    onClosed();
  }

  // ======================================================
  // 🔐 LOGIN FUNCTION
  // ======================================================
  void _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      showError("Username dan password harus diisi");
      return;
    }

    setState(() => _loading = true);

    try {
      final user = await AuthService()
          .login(_usernameController.text.trim(), _passwordController.text.trim());

      if (user.token != null && user.idSertifikat != null) {
        await SessionManager.saveSession(user.token!, user.idSertifikat!);
      }

      if (!mounted) return;

      showSuccess("Login berhasil");

      // 🔥 FIXED: Navigasi setelah dialog sukses menutup
      await showSuccessDialogAutoClose(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(idSertifikat: user.idSertifikat ?? 0),
          ),
        );
      });
    } catch (e) {
      if (!mounted) return;
      final msg = extractErrorMessage(e);
      showError(msg);
    }

    setState(() => _loading = false);
  }

  // ======================================================
  // UI TIDAK DIUBAH
  // ======================================================
  @override
  Widget build(BuildContext context) {
    final pastelBlue = Colors.blue.shade300;
    final pastelTeal = Colors.teal.shade100;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FF),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [pastelBlue.withOpacity(0.3), pastelTeal.withOpacity(0.3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: pastelBlue.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.lock_rounded,
                          size: 50, color: Colors.blue.shade400),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Text(
                    "Selamat Datang 👋",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Silakan masuk ke akun Anda",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  const SizedBox(height: 25),

                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _usernameController,
                          label: "Username",
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 15),

                        _buildTextField(
                          controller: _passwordController,
                          label: "Password",
                          icon: Icons.lock_outline,
                          obscure: true,
                        ),
                        const SizedBox(height: 22),

                        _loading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade400,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 4,
                                  shadowColor:
                                      Colors.blueAccent.withOpacity(0.3),
                                ),
                                child: const Text(
                                  "Masuk",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                        const SizedBox(height: 14),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Belum punya akun?",
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RegisterPage(),
                                ),
                              ),
                              child: Text(
                                "Daftar Sekarang",
                                style: TextStyle(
                                  color: Colors.blue.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  Text(
                    "© 2025 Magang App | All rights reserved",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
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
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      ),
    );
  }
}
