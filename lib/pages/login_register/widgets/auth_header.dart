import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AuthHeader extends StatelessWidget {
  final String title;

  const AuthHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: Lottie.asset(
            'assets/images/lottie_logo1.json',
            fit: BoxFit.contain,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade400,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
