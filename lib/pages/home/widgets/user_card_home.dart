import 'package:flutter/material.dart';

class UserGreetingCard extends StatelessWidget {
  final String name;

  const UserGreetingCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: const Color(0xFF077A7D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            'Halo, $name!',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
