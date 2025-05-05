import 'package:app_absent/pages/login_register/splash_page.dart';
import 'package:app_absent/services/auth/auth_services.dart';
import 'package:app_absent/providers/profil_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Future<bool> editProfile(BuildContext context, String name) async {
    setLoading(true);
    setMessage('');
    try {
      final response = await _authService.updateProfile(name);

      // Cek key dengan aman
      final isSuccess = response['success'] == true;

      setMessage(response['message'] ?? '');

      if (isSuccess) {
        // Update data profile
        await Provider.of<ProfileProvider>(
          context,
          listen: false,
        ).fetchProfile();

        // Navigasi ke splash page
        setLoading(false);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const SplashPage()),
          (route) => false,
        );
        return true;
      } else {
        setLoading(false);
        return false;
      }
    } catch (e) {
      setMessage('Gagal memperbarui profil: $e');
      setLoading(false);
      return false;
    }
  }
}
