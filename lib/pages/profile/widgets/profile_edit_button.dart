import 'package:app_absent/pages/profile/edit_profile/edit_page.dart';
import 'package:flutter/material.dart';

class ProfileEditButton extends StatelessWidget {
  final VoidCallback onUpdated;

  const ProfileEditButton({super.key, required this.onUpdated});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          final updated = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditProfilePage()),
          );
          if (updated == true) onUpdated();
        },
        child: const Text(
          'Edit Profil',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
