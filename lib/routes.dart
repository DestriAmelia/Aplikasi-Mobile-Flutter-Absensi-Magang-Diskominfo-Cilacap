import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/attendance_page.dart';
import 'pages/izin_page.dart';
import 'pages/profile_page.dart';
import 'pages/announcement_page.dart';
import 'models/announcement_model.dart';

class Routes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const attendance = '/attendance';
  static const izin = '/izin';
  static const profile = '/profile';
  static const announcement = '/announcement';
}

final Map<String, WidgetBuilder> appRoutes = {
  Routes.login: (_) => const LoginPage(),
  Routes.register: (_) => const RegisterPage(),
  Routes.izin: (_) => const IzinPage(),

  // HomePage (tidak perlu token, ambil dari SessionManager)
  Routes.home: (context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is int) {
      return HomePage(idSertifikat: args);
    }
    return const Scaffold(
      body: Center(child: Text("idSertifikat tidak diberikan untuk HomePage")),
    );
  },

  // AttendancePage
  Routes.attendance: (context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is int) {
      return AttendancePage(idSertifikat: args);
    }
    return const Scaffold(
      body: Center(child: Text("idSertifikat tidak diberikan untuk Absensi")),
    );
  },

  // IzinPage
  //Routes.izin: (_) => const IzinPage(),

  // ProfilePage
  Routes.profile: (context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is int) {
      return ProfilePage();
    }
    return const Scaffold(
      body: Center(child: Text("idSertifikat tidak diberikan untuk Profile")),
    );
  },

Routes.announcement: (context) => const AnnouncementPage(),

};
