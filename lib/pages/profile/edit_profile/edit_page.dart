import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_absent/providers/edit_porfil_provider.dart';
import 'package:app_absent/providers/profil_provider.dart';
import 'package:app_absent/pages/profile/edit_profile/widgets/name_input_field.dart';
import 'package:app_absent/pages/profile/edit_profile/widgets/save_cancel_buttons.dart';
import 'package:app_absent/pages/profile/edit_profile/widgets/update_message_display.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = Provider.of<ProfileProvider>(
        context,
        listen: false,
      );
      _nameController.text = profileProvider.profileData['name'] ?? '';
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSave(EditProfileProvider provider) async {
    if (_formKey.currentState!.validate()) {
      await provider.editProfile(context, _nameController.text);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/splash', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editProfileProvider = Provider.of<EditProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profil',
          style: TextStyle(fontSize: 20, color: Color(0xFF06202B)),
        ),
        backgroundColor: const Color(0xFF7AE2CF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Center(
                child: Text(
                  'Perbarui profil Anda',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF06202B),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              NameInputField(controller: _nameController),
              const SizedBox(height: 30),
              SaveCancelButtons(
                isLoading: editProfileProvider.isLoading,
                onSave: () => _handleSave(editProfileProvider),
              ),
              const SizedBox(height: 30),
              if (editProfileProvider.message.isNotEmpty)
                Center(
                  child: UpdateMessageDisplay(
                    message: editProfileProvider.message,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
