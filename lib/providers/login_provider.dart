// import 'package:app_absent/services/auth_service.dart';
import 'package:app_absent/services/auth_services.dart';
import 'package:app_absent/model/login_model.dart';
import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
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

  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    setLoading(true);
    try {
      LoginResponse response = await _authService.login(email, password);
      if (response.data != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setErrorMessage(response.message);
      }
    } catch (e) {
      setErrorMessage('Terjadi kesalahan: $e');
    } finally {
      setLoading(false);
    }
  }
}
