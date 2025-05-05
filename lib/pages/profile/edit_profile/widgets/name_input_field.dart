import 'package:flutter/material.dart';

class NameInputField extends StatelessWidget {
  final TextEditingController controller;

  const NameInputField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Nama Lengkap',
        labelStyle: const TextStyle(color: Color(0xFF077A7D)),
        hintText: 'Masukkan nama lengkap Anda',
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF077A7D), width: 2),
        ),
        prefixIcon: const Icon(Icons.person, color: Color(0xFF077A7D)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nama wajib diisi.';
        }
        return null;
      },
    );
  }
}
