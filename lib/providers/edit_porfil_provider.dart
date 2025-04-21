import 'package:app_absent/pages_app/profil_page.dart';
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
    setMessage('');
    try {
      final response = await _authService.updateProfile(name);
      setMessage(response['message']);
      if (response['success'] == true) {
        setLoading(false);
        // Navigasi kembali ke ProfilePage setelah berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      } else {
        setLoading(false);
      }
    } catch (e) {
      setMessage('Gagal memperbarui profil: $e');
      setLoading(false);
    }
  }
}
