import 'package:app_absent/pages_app/absent_page.dart';
import 'package:flutter/material.dart';
import 'pages_app/home_page.dart';
import 'pages_app/profil_page.dart';
import 'pages_app/edit_page.dart';
import 'pages_app/login_page.dart';
import 'pages_app/register_page.dart'; // Tambahkan import halaman registrasi

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Absen',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/absen': (context) => AbsenPage(),
        '/edit': (context) => EditProfilePage(),
        '/register': (context) => RegisterPage(), // Tambahkan rute registrasi
      },
    );
  }
}
