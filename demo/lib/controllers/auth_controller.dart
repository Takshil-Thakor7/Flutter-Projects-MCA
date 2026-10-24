import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';

/// Controller handling authentication actions and state
class AuthController extends ChangeNotifier {
  final ApiService _apiService;

  AuthController({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  /// Log in with username and password
  Future<UserModel?> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _apiService.login(username, password);
      _currentUser = user;
      return user;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Register new user
  Future<UserModel?> register({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _apiService.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        username: username,
        password: password,
      );
      return user;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Log out the current user
  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear any error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
