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

  bool get isLoading => _isLoading;
  String get status => _status;
  String get alasanIzin => _alasanIzin;
  LatLng? get currentLocation => _currentLocation;
  GoogleMapController? get mapController => _mapController;
  String get message => _message;

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

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setCurrentLocation(LatLng(position.latitude, position.longitude));
    } catch (e) {
      print('Error getting location: $e');
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

      Map<String, dynamic> response;
      if (_status == 'masuk') {
        response = await _authService.checkIn(
          checkInLat.toString(),
          checkInLng.toString(),
          checkInAddress,
          _status,
        );
      } else {
        if (_alasanIzin.isEmpty) {
          setMessage('Alasan izin wajib diisi.');
          setLoading(false);
          return;
        }
        response = await _authService.checkIn(
          checkInLat.toString(),
          checkInLng.toString(),
          checkInAddress,
          _status,
          alasanIzin: _alasanIzin,
        );
      }

      setMessage(response['message']);
    } catch (e) {
      setMessage('Terjadi kesalahan: $e');
    } finally {
      setLoading(false);
    }
  }
}
