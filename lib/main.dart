import 'package:app_absent/pages_app/absent_page.dart';
import 'package:app_absent/pages_app/history_absen_page.dart';
import 'package:app_absent/pages_app/splash_page.dart';
import 'package:app_absent/providers/absen_provider.dart';
import 'package:app_absent/providers/edit_porfil_provider.dart';
import 'package:app_absent/providers/history_absen_provider.dart';
import 'package:app_absent/providers/home_provider.dart';
import 'package:app_absent/providers/login_provider.dart';
import 'package:app_absent/providers/profil_provider.dart';
import 'package:app_absent/providers/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages_app/home_page.dart';
import 'pages_app/profil_page.dart';
import 'pages_app/edit_page.dart';
import 'pages_app/login_page.dart';
import 'pages_app/register_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AbsenProvider()),
        ChangeNotifierProvider(create: (context) => EditProfileProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => RegisterProvider()),
        ChangeNotifierProvider(create: (context) => RiwayatAbsenProvider()),
      ],
      child: MaterialApp(
        title: 'App Absent',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/splash',

        routes: {
          '/splash': (context) => SplashPage(),
          '/login': (context) => LoginPage(),
          '/home': (context) => HomePage(),
          '/profile': (context) => ProfilePage(),
          '/absen': (context) => AbsentPage(),
          '/edit': (context) => EditProfilePage(),
          '/register': (context) => RegisterPage(),
          '/history_absen': (context) => RiwayatAbsenPage(),
        },
      ),
    );
  }
}
