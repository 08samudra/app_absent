import 'package:app_absent/services/auth_services.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final AuthService _authService = AuthService();

  Future<void> _editProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _authService.updateProfile(_nameController.text);
        if (response['message'] == 'Profil berhasil diperbarui') {
          Navigator.pop(context); // Kembali ke halaman profil
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(response['message'])));
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memperbarui profil: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama wajib diisi.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _editProfile, child: Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }
}
