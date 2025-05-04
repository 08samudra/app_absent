import 'dart:convert';
import 'package:app_absent/model/login_model.dart';
import 'package:http/http.dart' as http;
import 'endpoints.dart';

class AuthRepository {
  Future<LoginResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(Endpoints.baseUrl + Endpoints.login),
      body: {'email': email, 'password': password},
      headers: {'Accept': 'application/json'},
    );

    return LoginResponse.fromJson(json.decode(response.body));
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse(Endpoints.baseUrl + Endpoints.register),
      body: {'name': name, 'email': email, 'password': password},
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> checkIn(
    String checkInLat,
    String checkInLng,
    String checkInAddress,
    String status, {
    String? alasanIzin,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoints.baseUrl + Endpoints.checkIn),
      body: {
        'check_in_lat': checkInLat,
        'check_in_lng': checkInLng,
        'check_in_address': checkInAddress,
        'status': status,
        if (alasanIzin != null) 'alasan_izin': alasanIzin,
      },
    );
    return json.decode(response.body);
  }

  // Tambahkan fungsi checkOut
  Future<Map<String, dynamic>> checkOut(
    String checkOutLat,
    String checkOutLng,
    String checkOutAddress,
  ) async {
    final response = await http.post(
      Uri.parse(Endpoints.baseUrl + Endpoints.checkOut),
      body: {
        'check_out_lat': checkOutLat,
        'check_out_lng': checkOutLng,
        'check_out_address': checkOutAddress,
      },
    );
    return json.decode(response.body);
  }
}
