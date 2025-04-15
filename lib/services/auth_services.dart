import 'dart:convert';
import 'package:app_absent/services/user_services.dart';
import 'package:http/http.dart' as http;
import 'endpoint.dart';
import 'login_model.dart';

class AuthService {
  final UserService _userService = UserService();

  Future<LoginResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(Endpoints.baseUrl + Endpoints.login),
      body: {'email': email, 'password': password},
    );

    final loginResponse = LoginResponse.fromJson(json.decode(response.body));

    if (loginResponse.data != null) {
      await _userService.saveToken(loginResponse.data!.token);
    }

    return loginResponse;
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
    final token = await _userService.getToken();
    final response = await http.post(
      Uri.parse(Endpoints.baseUrl + Endpoints.checkIn),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
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

  Future<Map<String, dynamic>> checkOut(
    String checkOutLat,
    String checkOutLng,
    String checkOutAddress,
  ) async {
    final token = await _userService.getToken();
    final response = await http.post(
      Uri.parse(Endpoints.baseUrl + Endpoints.checkOut),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'check_out_lat': checkOutLat,
        'check_out_lng': checkOutLng,
        'check_out_address': checkOutAddress,
      },
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getProfile() async {
    final token = await _userService.getToken();
    final response = await http.get(
      Uri.parse(Endpoints.baseUrl + Endpoints.profile),
      headers: {'Authorization': 'Bearer $token'},
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> updateProfile(String name) async {
    final token = await _userService.getToken();
    final response = await http.put(
      Uri.parse(Endpoints.baseUrl + Endpoints.profile),
      headers: {'Authorization': 'Bearer $token'},
      body: {'name': name},
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getAbsenHistory(String startDate) async {
    final token = await _userService.getToken();
    final response = await http.get(
      Uri.parse(
        Endpoints.baseUrl + Endpoints.absenHistory + '?start=$startDate',
      ),
      headers: {'Authorization': 'Bearer $token'},
    );
    return json.decode(response.body);
  }
}
