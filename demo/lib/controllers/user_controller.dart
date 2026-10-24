import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';

/// Controller handling community user directory and search filtering
class UserController extends ChangeNotifier {
  final ApiService _apiService;

  UserController({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  List<UserModel> _users = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  /// Returns users matching the search query
  List<UserModel> get filteredUsers {
    if (_searchQuery.isEmpty) return _users;

    final lower = _searchQuery.toLowerCase();
    return _users.where((user) {
      final nameEmail = '${user.firstName} ${user.lastName} ${user.email}'
          .toLowerCase();
      return nameEmail.contains(lower);
    }).toList();
  }

  /// Fetch users from the API
  Future<void> fetchUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _users = await _apiService.getUsers();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update the search filter query
  void updateSearchQuery(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  /// Reset search query
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }
}
