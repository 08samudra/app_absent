import 'package:app_absent/services/auth/auth_services.dart';
import 'package:flutter/material.dart';

class RegisterProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
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
        ).showSnackBar(const SnackBar(content: Text('Registrasi berhasil!')));
        Navigator.pop(context); // Kembali ke halaman login
      } else {
        String errorText = responseData['message'] ?? 'Registrasi gagal.';
        if (responseData['errors'] != null) {
          // Ambil semua error dari key `errors` (map of lists)
          final errors = responseData['errors'] as Map<String, dynamic>;
          errorText = errors.values
              .map((e) => (e as List).join('\n'))
              .join('\n'); // gabungkan semua error

          // Alternatif jika hanya ingin 1 error: errorText = errors['email']?[0];
        }

        _showErrorDialog(context, errorText);
      }
    } catch (e) {
      _showErrorDialog(context, 'Terjadi kesalahan: $e');
    } finally {
      setLoading(false);
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Registrasi Gagal'),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }
}
