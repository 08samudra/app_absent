import 'dart:convert';
import 'package:app_absent/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class AbsenPage extends StatefulWidget {
  @override
  _AbsenPageState createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsenPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String _status = 'masuk';
  String _alasanIzin = '';
  LatLng? _currentLocation;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _checkIn() async {
    setState(() {
      _isLoading = true;
    });

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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Alasan izin wajib diisi.')));
          setState(() {
            _isLoading = false;
          });
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

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response['message'])));
    } on FormatException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan format: $e')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Absen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            if (_currentLocation != null)
              Expanded(
                flex: 2,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation!,
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('currentLocation'),
                      position: _currentLocation!,
                    ),
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                ),
              ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _status,
              items:
                  <String>['masuk', 'izin'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _status = value!;
                });
              },
            ),
            if (_status == 'izin')
              TextField(
                decoration: InputDecoration(labelText: 'Alasan Izin'),
                onChanged: (value) {
                  _alasanIzin = value;
                },
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _checkIn,
              child: Text('Absen'),
            ),
            if (_isLoading) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
