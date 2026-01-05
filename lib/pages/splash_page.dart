import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2)); // efek loading

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (!mounted) return;

    Future.microtask(() {
      if (token != null && token.isNotEmpty) {
        // ✅ Ada token → langsung ke dashboard
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        // ❌ Tidak ada token → ke login
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.business, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              "Diskominfo Cilacap",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Alamat: Jl. Jendral Sudirman No. 123, Cilacap\n"
              "Telp: (0282) 123456\n"
              "Email: diskominfo@cilacapkab.go.id",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
