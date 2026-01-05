// import 'package:flutter/material.dart';
// import '../services/auth_service.dart';

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   String? _role = "siswa";
//   bool _loading = false;

//   void _register() async {
//     if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Username dan Password harus diisi")),
//       );
//       return;
//     }

//     setState(() => _loading = true);
//     try {
//       await AuthService().register(
//         _usernameController.text.trim(),
//         _passwordController.text.trim(),
//         role: _role ?? "siswa",
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Pendaftaran berhasil, silakan login"),
//           backgroundColor: Colors.green,
//         ),
//       );

//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Register gagal: $e"), backgroundColor: Colors.red),
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
//                   // 🌸 Icon Header
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
//                       child: Icon(Icons.person_add_alt_1_rounded,
//                           size: 50, color: Colors.blue.shade400),
//                     ),
//                   ),

//                   const SizedBox(height: 25),

//                   // 🩵 Title
//                   Text(
//                     "Buat Akun Baru ✨",
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue.shade800,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   const Text(
//                     "Isi data di bawah untuk mendaftar",
//                     style: TextStyle(color: Colors.grey, fontSize: 15),
//                   ),
//                   const SizedBox(height: 25),

//                   // 🌼 Card Register
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
//                           controller: _usernameController,
//                           label: "Username",
//                           icon: Icons.person_outline,
//                         ),
//                         const SizedBox(height: 14),
//                         _buildTextField(
//                           controller: _passwordController,
//                           label: "Password",
//                           icon: Icons.lock_outline,
//                           obscure: true,
//                         ),
//                         const SizedBox(height: 14),

//                         // Dropdown Role
//                         DropdownButtonFormField<String>(
//                           value: _role,
//                           decoration: InputDecoration(
//                             prefixIcon:
//                                 Icon(Icons.group_outlined, color: Colors.blue.shade400),
//                             labelText: "Pilih Role",
//                             filled: true,
//                             fillColor: Colors.blue.shade50.withOpacity(0.3),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(14),
//                               borderSide: BorderSide.none,
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(14),
//                               borderSide:
//                                   BorderSide(color: Colors.blue.shade400, width: 2),
//                             ),
//                           ),
//                           items: const [
//                             DropdownMenuItem(
//                               value: "siswa",
//                               child: Text("Siswa"),
//                             ),
//                             DropdownMenuItem(
//                               value: "mentor",
//                               child: Text("Mentor"),
//                             ),
//                           ],
//                           onChanged: (v) => setState(() => _role = v),
//                         ),

//                         const SizedBox(height: 25),

//                         // 🔹 Tombol Daftar
//                         _loading
//                             ? const CircularProgressIndicator()
//                             : ElevatedButton(
//                                 onPressed: _register,
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
//                                   "Daftar Sekarang",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold, fontSize: 16),
//                                 ),
//                               ),
//                         const SizedBox(height: 14),

//                         // 🔸 Kembali ke Login
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Text(
//                               "Sudah punya akun?",
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                             TextButton(
//                               onPressed: () => Navigator.pop(context),
//                               child: Text(
//                                 "Login",
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

//                   // Footer
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

import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _role = "siswa";
  bool _loading = false;

  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // =====================================================
  // 🔔 DIALOG NOTIFIKASI DENGAN ANIMASI + AUTO CLOSE
  // =====================================================
  void _showNotificationDialog({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
    bool autoClose = false,
    bool animatedIcon = false,
  }) {
    if (animatedIcon) {
      _animController.reset();
      _animController.forward();
    }

    showDialog(
      context: context,
      barrierDismissible: !autoClose,
      builder: (_) {
        if (autoClose) {
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) Navigator.pop(context);
          });
        }

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                animatedIcon
                    ? ScaleTransition(
                        scale: _scaleAnim,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, size: 60, color: color),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, size: 48, color: color),
                      ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 24),
                if (!autoClose)
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade400,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(130, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Mengerti",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =====================================================
  // 🔐 REGISTER FUNCTION
  // =====================================================
  void _register() async {
    if (_usernameController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      _showNotificationDialog(
        title: "Form Belum Lengkap",
        message: "Username dan password harus diisi.",
        icon: Icons.warning_amber_rounded,
        color: Colors.orange,
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await AuthService().register(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
        role: _role ?? "siswa",
      );

      if (!mounted) return;

      // 🎉 Sukses → tampilkan animasi + auto close
      _showNotificationDialog(
        title: "Pendaftaran Berhasil!",
        message: "Akun Anda berhasil dibuat. Silakan login.",
        icon: Icons.check_circle_rounded,
        color: Colors.green,
        autoClose: true,
        animatedIcon: true,
      );

      // Auto navigate ke Login setelah dialog tertutup
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.pop(context);
      });
    } catch (e) {
      if (!mounted) return;

      final err = e.toString().toLowerCase();

      // Deteksi username sudah dipakai
      if (err.contains("username") && err.contains("sudah")) {
        _showNotificationDialog(
          title: "Username Sudah Digunakan",
          message:
              "Silakan gunakan username lain, karena username ini sudah terdaftar.",
          icon: Icons.error_outline_rounded,
          color: Colors.red,
        );
      } else {
        _showNotificationDialog(
          title: "Pendaftaran Gagal",
          message: "Register gagal: $e",
          icon: Icons.error_outline_rounded,
          color: Colors.red,
        );
      }
    }

    setState(() => _loading = false);
  }

  // =====================================================
  // 🧱 UI REGISTER PAGE (TIDAK DIUBAH)
  // =====================================================
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
                  // Icon header
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
                      child: Icon(Icons.person_add_alt_1_rounded,
                          size: 50, color: Colors.blue.shade400),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "Buat Akun Baru ✨",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Isi data di bawah untuk mendaftar",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  const SizedBox(height: 25),

                  // Card form
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
                        const SizedBox(height: 14),
                        _buildTextField(
                          controller: _passwordController,
                          label: "Password",
                          icon: Icons.lock_outline,
                          obscure: true,
                        ),
                        const SizedBox(height: 14),

                        DropdownButtonFormField<String>(
                          value: _role,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.group_outlined,
                                color: Colors.blue.shade400),
                            labelText: "Pilih Role",
                            filled: true,
                            fillColor: Colors.blue.shade50.withOpacity(0.3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade400, width: 2),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: "siswa",
                              child: Text("Siswa"),
                            ),
                            DropdownMenuItem(
                              value: "mentor",
                              child: Text("Mentor"),
                            ),
                          ],
                          onChanged: (v) => setState(() => _role = v),
                        ),
                        const SizedBox(height: 25),

                        _loading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade400,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 4,
                                ),
                                child: const Text(
                                  "Daftar Sekarang",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
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
      ),
    );
  }
}