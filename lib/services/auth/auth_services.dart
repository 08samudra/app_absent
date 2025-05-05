import 'dart:convert';
import 'package:app_absent/model/login_model.dart';
import 'package:app_absent/services/auth/user_services.dart';
import 'package:http/http.dart' as http;
import '../endpoint/endpoints.dart';
import 'auth_repository.dart';

class AuthService {
  final UserService _userService = UserService();
  final AuthRepository _authRepository = AuthRepository();

  Future<LoginResponse> login(String email, String password) async {
    final loginResponse = await _authRepository.login(email, password);
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
    return _authRepository.register(name, email, password);
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

  Future<Map<String, dynamic>> getAbsenHistory({
    String? startDate,
    String? endDate,
  }) async {
    final token = await _userService.getToken();
    Uri uri = Uri.parse(Endpoints.baseUrl + Endpoints.absenHistory);
    if (startDate != null && endDate != null) {
      uri = uri.replace(
        queryParameters: {'start_date': startDate, 'end_date': endDate},
      );
    } else if (startDate != null) {
      uri = uri.replace(queryParameters: {'start_date': startDate});
    } else if (endDate != null) {
      uri = uri.replace(queryParameters: {'end_date': endDate});
    }

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> deleteAbsen(String id) async {
    final token = await _userService.getToken();
    final response = await http.delete(
      Uri.parse("${Endpoints.baseUrl}/api/absen/$id"),
      headers: {'Authorization': 'Bearer $token'},
    );
    return json.decode(response.body);
  }
}
