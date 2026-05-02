import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../../../../core/constants/app_constants.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // Step 1: Hit /auth/login untuk dapat token
  Future<String> loginGetToken(String username, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'username': username,
        'password': password,
      });
      return response.data['token'] as String;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 400) {
        throw Exception('Username atau password salah');
      }
      throw Exception('Gagal login, cek koneksi internet');
    } catch (e) {
      throw Exception('Login gagal');
    }
  }

  // Step 2: Ambil semua users, cari yang match username & password
  Future<UserModel> getUserByCredentials(String username, String password) async {
    try {
      final response = await _dio.get('/users');
      final List users = response.data;
      final match = users.firstWhere(
        (u) => u['username'] == username && u['password'] == password,
        orElse: () => null,
      );
      if (match == null) throw Exception('User tidak ditemukan');
      return UserModel.fromJson(match);
    } on DioException catch (_) {
      throw Exception('Gagal mengambil data user');
    }
  }
}
