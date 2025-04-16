// import 'package:app_absent/services/auth_service.dart';
import 'package:app_absent/services/auth_services.dart';
import 'package:flutter/material.dart';

class RegisterProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setErrorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  Future<void> register(
    BuildContext context,
    String name,
    String email,
    String password,
  ) async {
    setLoading(true);
    try {
      final responseData = await _authService.register(name, email, password);
      if (responseData['message'] == 'Registrasi berhasil') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Registrasi berhasil!')));
        Navigator.pop(context); // Kembali ke halaman login
      } else {
        if (responseData['errors'] != null) {
          setErrorMessage(responseData['errors'].values.join('\n'));
        } else {
          setErrorMessage(responseData['message']);
        }
      }
    } catch (e) {
      setErrorMessage('Terjadi kesalahan: $e');
    } finally {
      setLoading(false);
    }
  }
}
