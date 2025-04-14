import 'package:app_absent/services/auth_services.dart';
import 'package:flutter/material.dart';
// import 'auth_services.dart'; // Import AuthService

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  String _checkInMessage = '';
  String _checkOutMessage = '';

  Future<void> _checkIn() async {
    try {
      // Simulasi data lokasi dan alamat
      final response = await _authService.checkIn(
        '-6.2', // Latitude
        '106.8', // Longitude
        'Jakarta', // Alamat
        'masuk', // Status
      );

      setState(() {
        _checkInMessage = response['message'];
      });
    } catch (e) {
      setState(() {
        _checkInMessage = 'Gagal check-in: $e';
      });
    }
  }

  Future<void> _checkOut() async {
    try {
      // Simulasi data lokasi dan alamat
      final response = await _authService.checkOut(
        '-6.2', // Latitude
        '106.8', // Longitude
        'Jakarta', // Alamat
      );

      setState(() {
        _checkOutMessage = response['message'];
      });
    } catch (e) {
      setState(() {
        _checkOutMessage = 'Gagal check-out: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Selamat datang!'),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _checkIn, child: Text('Check-in')),
            if (_checkInMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _checkInMessage,
                  style: TextStyle(color: Colors.green),
                ),
              ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _checkOut, child: Text('Check-out')),
            if (_checkOutMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _checkOutMessage,
                  style: TextStyle(color: Colors.blue),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
