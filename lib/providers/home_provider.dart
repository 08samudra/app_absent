// import 'package:app_absent/services/auth_service.dart';
import 'package:app_absent/services/auth_services.dart';
// import 'package:app_absent/services/user_service.dart';
import 'package:app_absent/services/user_services.dart';
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  Map<String, dynamic> _profileData = {};
  bool _isLoading = true;
  String _errorMessage = '';

  Map<String, dynamic> get profileData => _profileData;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setProfileData(Map<String, dynamic> value) {
    _profileData = value;
    notifyListeners();
  }

  void setErrorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  Future<void> fetchProfile(BuildContext context) async {
    setLoading(true);
    try {
      final token = await _userService.getToken();
      if (token == null) {
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }
      final response = await _authService.getProfile();
      setProfileData(response['data']);
    } catch (e) {
      setErrorMessage('Gagal memuat profil: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat profil: $e')));
    } finally {
      setLoading(false);
    }
  }

  Future<void> removeToken() async {
    await _userService.removeToken();
  }
}
