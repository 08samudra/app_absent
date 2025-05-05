import 'package:app_absent/services/auth/auth_services.dart';
import 'package:flutter/material.dart';

class RiwayatAbsenProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  List<dynamic> _historyAbsens = [];
  bool _isLoading = false;
  String _errorMessage = '';
  int _totalAbsen = 0;
  int _totalIzin = 0;

  List<dynamic> get historyAbsens => _historyAbsens;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  int get totalAbsen => _totalAbsen;
  int get totalIzin => _totalIzin;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setErrorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  void setHistoryAbsens(List<dynamic> value) {
    _historyAbsens = value;
    _calculateTotals();
    notifyListeners();
  }

  void _calculateTotals() {
    _totalAbsen =
        _historyAbsens.where((absen) => absen['status'] == 'masuk').length;
    _totalIzin =
        _historyAbsens.where((absen) => absen['status'] == 'izin').length;
    notifyListeners();
  }

  Future<void> getHistoryAbsens({String? startDate, String? endDate}) async {
    setLoading(true);
    setErrorMessage('');
    try {
      final response = await _authService.getAbsenHistory(
        startDate: startDate,
        endDate: endDate,
      );
      if (response['data'] != null) {
        setHistoryAbsens(response['data']);
      } else {
        setHistoryAbsens([]);
        setErrorMessage(response['message'] ?? 'Tidak ada riwayat absensi.');
      }
    } catch (e) {
      setErrorMessage('Terjadi kesalahan saat mengambil riwayat absensi: $e');
      setHistoryAbsens([]);
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteAbsen(String id) async {
    try {
      final response = await _authService.deleteAbsen(id);
      if (response['data'] != null) {
        _historyAbsens.removeWhere((absen) => absen['id'].toString() == id);
        _calculateTotals();
        notifyListeners();
      } else {
        throw Exception(response['message'] ?? 'Gagal menghapus absensi.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat menghapus absensi: $e');
    }
  }
}
