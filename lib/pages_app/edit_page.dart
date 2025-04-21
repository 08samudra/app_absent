import 'package:app_absent/providers/edit_porfil_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Consumer<EditProfileProvider>(
            builder: (context, editProfileProvider, child) {
              return Column(
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
                  ElevatedButton(
                    onPressed:
                        editProfileProvider.isLoading
                            ? null
                            : () {
                              if (_formKey.currentState!.validate()) {
                                editProfileProvider.editProfile(
                                  context,
                                  _nameController.text,
                                );
                              }
                            },
                    child: Text('Simpan'),
                  ),
                  if (editProfileProvider.isLoading)
                    CircularProgressIndicator(),
                  if (editProfileProvider.message.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(editProfileProvider.message),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
