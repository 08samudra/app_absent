import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final Map<String, dynamic> profile;

  const ProfileHeader({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = profile['name'] ?? 'Tidak ada nama';
    final email = profile['email'] ?? 'Tidak ada email';

    return Column(
      children: [
        const CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, size: 70, color: Colors.white),
        ),
        const SizedBox(height: 20),
        Text(
          name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          email,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
