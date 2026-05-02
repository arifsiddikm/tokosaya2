import 'package:flutter/material.dart';
import '../data/models/user_model.dart';
import '../data/datasource/auth_service.dart';

enum AuthStatus { idle, loading, success, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  AuthStatus _status = AuthStatus.idle;
  UserModel? _currentUser;
  String? _token;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserModel? get currentUser => _currentUser;
  String? get token => _token;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null && _token != null;

  Future<bool> login(String username, String password) async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      notifyListeners();

      // Hit auth/login dulu untuk token
      _token = await _service.loginGetToken(username, password);

      // Lalu ambil data user lengkap
      _currentUser = await _service.getUserByCredentials(username, password);

      _status = AuthStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    _token = null;
    _status = AuthStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    _status = AuthStatus.idle;
    notifyListeners();
  }
}
