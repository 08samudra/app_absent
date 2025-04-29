// import 'package:app_absent/services/auth_service.dart';
import 'package:app_absent/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AbsenProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String _status = 'masuk';
  String _alasanIzin = '';
  LatLng? _currentLocation;
  GoogleMapController? _mapController;
  String _message = '';
  bool _isCheckOutLoading = false; // Tambahkan loading state untuk check out
  String _checkOutMessage = ''; // Tambahkan pesan untuk check out
  bool _isCheckOutEnabled = false; // State untuk mengontrol tombol check out

  // Koordinat kantor (ganti dengan koordinat sebenarnya)
  static const double kantorLatitude =
      -6.210881; // Ganti dengan latitude kantor Anda
  static const double kantorLongitude =
      106.812942; // Ganti dengan longitude kantor Anda
  static const double allowedRadius =
      100; // Radius dalam meter (misalnya 100 meter)

  bool get isLoading => _isLoading;
  String get status => _status;
  String get alasanIzin => _alasanIzin;
  LatLng? get currentLocation => _currentLocation;
  GoogleMapController? get mapController => _mapController;
  String get message => _message;
  bool get isCheckOutLoading => _isCheckOutLoading;
  String get checkOutMessage => _checkOutMessage;
  bool get isCheckOutEnabled => _isCheckOutEnabled;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setStatus(String value) {
    _status = value;
    notifyListeners();
  }

  void setAlasanIzin(String value) {
    _alasanIzin = value;
    notifyListeners();
  }

  void setCurrentLocation(LatLng? value) {
    _currentLocation = value;
    notifyListeners();
  }

  void setMapController(GoogleMapController? value) {
    _mapController = value;
    notifyListeners();
  }

  void setMessage(String value) {
    _message = value;
    notifyListeners();
  }

  void setCheckOutLoading(bool value) {
    _isCheckOutLoading = value;
    notifyListeners();
  }

  void setCheckOutMessage(String value) {
    _checkOutMessage = value;
    notifyListeners();
  }

  void setIsCheckOutEnabled(bool value) {
    _isCheckOutEnabled = value;
    notifyListeners();
  }

  Future<LatLng?> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setCurrentLocation(LatLng(position.latitude, position.longitude));
      // Setelah mendapatkan lokasi, aktifkan tombol check out
      setIsCheckOutEnabled(true);
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print('Error getting location: $e');
      setIsCheckOutEnabled(
        false,
      ); // Nonaktifkan tombol jika gagal mendapatkan lokasi
      return null;
    }
  }

  Future<void> checkIn(BuildContext context) async {
    setLoading(true);

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double checkInLat = position.latitude;
      double checkInLng = position.longitude;
      String checkInAddress = 'Lokasi Tidak Diketahui';

      // Validasi jarak HANYA jika status adalah 'masuk'
      if (_status == 'Masuk') {
        // Hitung jarak antara lokasi pengguna dan kantor
        double distance = Geolocator.distanceBetween(
          checkInLat,
          checkInLng,
          kantorLatitude,
          kantorLongitude,
        );

        // Validasi jarak
        if (distance > allowedRadius) {
          setMessage(
            'Anda berada di luar radius absensi yang diperbolehkan (${allowedRadius} meter). Jarak Anda: ${distance.toStringAsFixed(2)} meter.',
          );
          setLoading(false);
          return;
        }
      } else if (_status == 'Izin' && _alasanIzin.isEmpty) {
        setMessage('Alasan izin wajib diisi.');
        setLoading(false);
        return;
      }

      Map<String, dynamic> response;
      response = await _authService.checkIn(
        checkInLat.toString(),
        checkInLng.toString(),
        checkInAddress,
        _status,
        alasanIzin: _status == 'izin' ? _alasanIzin : null,
      );

      setMessage(response['message']);
      // Setelah berhasil check in, mungkin perlu memperbarui UI atau state
    } catch (e) {
      setMessage('Terjadi kesalahan: $e');
    } finally {
      setLoading(false);
    }
  }

  // Tambahkan fungsi checkOutProcess
  Future<void> checkOutProcess(BuildContext context) async {
    setCheckOutLoading(true);
    setCheckOutMessage(''); // Reset pesan check out

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double checkOutLat = position.latitude;
      double checkOutLng = position.longitude;
      String checkOutAddress = 'Lokasi Tidak Diketahui';

      final response = await _authService.checkOut(
        checkOutLat.toString(),
        checkOutLng.toString(),
        checkOutAddress,
      );

      setCheckOutMessage(response['message']);
      // Mungkin perlu memperbarui UI atau state setelah berhasil check out
    } catch (e) {
      setCheckOutMessage('Terjadi kesalahan saat check out: $e');
    } finally {
      setCheckOutLoading(false);
    }
  }
}
