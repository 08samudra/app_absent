import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:app_absent/services/auth/user_services.dart';
import 'package:app_absent/providers/profil_provider.dart';
import 'package:app_absent/pages/login_register/widgets/auth_background.dart';

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
    Future.microtask(_checkToken);
  }

  Future<void> _checkToken() async {
    final token = await _userService.getToken();
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );

    await Future.delayed(const Duration(seconds: 2));

    if (token != null) {
      await profileProvider.fetchProfile();
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: Center(
          child: Lottie.asset(
            'assets/images/lottie_logo1.json',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
