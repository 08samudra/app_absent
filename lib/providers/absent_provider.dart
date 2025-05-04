import 'package:app_absent/geolocator/geo_service.dart';
import 'package:app_absent/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AbsenProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final LocationService _locationService = LocationService();

  bool _isLoading = false;
  String _status = 'masuk';
  String _alasanIzin = '';
  LatLng? _currentLocation;
  GoogleMapController? _mapController;
  String _message = '';
  bool _isCheckOutLoading = false;
  String _checkOutMessage = '';
  bool _isCheckOutEnabled = false;

  static const double kantorLatitude = -6.210881;
  static const double kantorLongitude = 106.812942;
  static const double allowedRadius = 100000;

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

  void clearMessages() {
    _message = '';
    _checkOutMessage = '';
    notifyListeners();
  }

  Future<LatLng?> getCurrentLocation() async {
    final granted = await _locationService.requestLocationPermission();
    if (!granted) {
      setMessage(
        'Izin lokasi ditolak. Silakan aktifkan secara manual di pengaturan.',
      );
      setIsCheckOutEnabled(false);
      return null;
    }

    final location = await _locationService.getCurrentLocation();
    setCurrentLocation(location);
    setIsCheckOutEnabled(location != null);
    return location;
  }

  Future<void> checkIn(BuildContext context) async {
    setLoading(true);

    try {
      final location = await _locationService.getCurrentLocation();
      if (location == null) {
        setMessage('Gagal mendapatkan lokasi');
        setLoading(false);
        return;
      }

      double distance = _locationService.calculateDistance(
        location,
        const LatLng(kantorLatitude, kantorLongitude),
      );

      if (_status.toLowerCase() == 'masuk' && distance > allowedRadius) {
        setMessage(
          'Anda berada di luar radius absensi. Jarak: ${distance.toStringAsFixed(2)} m.',
        );
        setLoading(false);
        return;
      }

      if (_status.toLowerCase() == 'izin' && _alasanIzin.isEmpty) {
        setMessage('Alasan izin wajib diisi.');
        setLoading(false);
        return;
      }

      final response = await _authService.checkIn(
        location.latitude.toString(),
        location.longitude.toString(),
        'Lokasi Tidak Diketahui',
        _status,
        alasanIzin: _status.toLowerCase() == 'izin' ? _alasanIzin : null,
      );

      setMessage(response['message']);
    } catch (e) {
      setMessage('Terjadi kesalahan: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> checkOutProcess(BuildContext context) async {
    setCheckOutLoading(true);
    setCheckOutMessage('');

    try {
      final location = await _locationService.getCurrentLocation();
      if (location == null) {
        setCheckOutMessage('Gagal mendapatkan lokasi');
        setCheckOutLoading(false);
        return;
      }

      final response = await _authService.checkOut(
        location.latitude.toString(),
        location.longitude.toString(),
        'Lokasi Tidak Diketahui',
      );

      setCheckOutMessage(response['message']);
    } catch (e) {
      setCheckOutMessage('Terjadi kesalahan saat check out: $e');
    } finally {
      setCheckOutLoading(false);
    }
  }
}
