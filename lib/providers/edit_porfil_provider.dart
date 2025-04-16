// import 'package:app_absent/services/auth_service.dart';
import 'package:app_absent/services/auth_services.dart';
import 'package:flutter/material.dart';

class EditProfileProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String _message = '';

  bool get isLoading => _isLoading;
  String get message => _message;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setMessage(String value) {
    _message = value;
    notifyListeners();
  }

  Future<void> editProfile(BuildContext context, String name) async {
    setLoading(true);
    try {
      final response = await _authService.updateProfile(name);
      setMessage(response['message']);
      if (response['message'] == 'Profil berhasil diperbarui') {
        Navigator.pop(context); // Kembali ke halaman profil
      }
    } catch (e) {
      setMessage('Gagal memperbarui profil: $e');
    } finally {
      setLoading(false);
    }
  }
}
