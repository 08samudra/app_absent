import 'package:app_absent/services/auth_services.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
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
}
