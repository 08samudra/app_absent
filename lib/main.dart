import 'package:app_absent/pages/history/history_absen_page.dart';
import 'package:app_absent/pages/login_register/splash_page.dart';
import 'package:app_absent/providers/absent_provider.dart';
import 'package:app_absent/providers/edit_porfil_provider.dart';
import 'package:app_absent/providers/history_absent_provider.dart';
import 'package:app_absent/providers/home_provider.dart';
import 'package:app_absent/providers/login_provider.dart';
import 'package:app_absent/providers/profil_provider.dart';
import 'package:app_absent/providers/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home/home_page.dart';
import 'pages/profile/profil_page.dart';
import 'pages/profile/edit_profile/edit_page.dart';
import 'pages/login_register/login_page.dart';
import 'pages/login_register/register_page.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
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
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: scaffoldMessengerKey,
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/splash',

        routes: {
          '/splash': (context) => SplashPage(),
          '/login': (context) => LoginPage(),
          '/home': (context) => HomePage(),
          '/profile': (context) => ProfilePage(),
          '/edit': (context) => EditProfilePage(),
          '/register': (context) => RegisterPage(),
          '/history_absen': (context) => RiwayatAbsenPage(),
        },
      ),
    );
  }
}
