import 'auth_repository.dart';
import 'login_model.dart';

class AuthService {
  final AuthRepository _authRepository = AuthRepository();

  Future<LoginResponse> login(String email, String password) async {
    return await _authRepository.login(email, password);
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    return await _authRepository.register(name, email, password);
  }

  Future<Map<String, dynamic>> checkIn(
    String checkInLat,
    String checkInLng,
    String checkInAddress,
    String status, {
    String? alasanIzin,
  }) async {
    return await _authRepository.checkIn(
      checkInLat,
      checkInLng,
      checkInAddress,
      status,
      alasanIzin: alasanIzin,
    );
  }

  Future<Map<String, dynamic>> checkOut(
    String checkOutLat,
    String checkOutLng,
    String checkOutAddress,
  ) async {
    return await _authRepository.checkOut(
      checkOutLat,
      checkOutLng,
      checkOutAddress,
    );
  }
}
