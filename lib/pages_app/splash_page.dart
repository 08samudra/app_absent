// import 'package:app_absent/services/endpoint.dart';
import 'package:app_absent/services/user_services.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final String? token = await _userService.getToken();

    await Future.delayed(const Duration(seconds: 2));

    if (token != null) {
      // Jika token ada, arahkan ke halaman home
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Jika token tidak ada, arahkan ke halaman login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/bg_screen3.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Selamat Datang di Aplikasi Absen',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
