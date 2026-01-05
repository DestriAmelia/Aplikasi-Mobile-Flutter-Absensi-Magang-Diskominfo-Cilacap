// import 'package:flutter/material.dart';
// import 'routes.dart';
// import 'pages/login_page.dart';
// import 'pages/home_page.dart';
// import 'utils/session_manager.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   Future<Widget> _decideStartPage() async {
//     final token = await SessionManager.getToken();
//     final idSertifikat = await SessionManager.getIdSertifikat();

//     if (token != null && idSertifikat != null) {
//       return HomePage(idSertifikat: idSertifikat);
//     }
//     return const LoginPage();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "SIMGANG APP",
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(primarySwatch: Colors.blue),
//       routes: appRoutes,
//       home: FutureBuilder<Widget>(
//         future: _decideStartPage(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState != ConnectionState.done) {
//             return const Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             );
//           }
//           return snapshot.data ?? const LoginPage();
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'routes.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'utils/session_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Menentukan halaman awal berdasarkan session (token & id sertifikat)
  Future<Widget> _decideStartPage() async {
    final token = await SessionManager.getToken();
    final idSertifikat = await SessionManager.getIdSertifikat();

    if (token != null && idSertifikat != null) {
      return HomePage(idSertifikat: idSertifikat);
    }
    return const LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SIMGANG APP",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF81C784)), // hijau pastel
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF81C784),
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      routes: appRoutes,
      home: FutureBuilder<Widget>(
        future: _decideStartPage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF81C784)),
                    SizedBox(height: 12),
                    Text(
                      "Memuat SIMGANG...",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Terjadi kesalahan: ${snapshot.error}"),
              ),
            );
          }

          return snapshot.data ?? const LoginPage();
        },
      ),
    );
  }
}
