import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import '../models/product_model.dart';

/// Service responsible for remote API communication with DummyJSON
class ApiService {
  static const String _baseUrl = 'https://dummyjson.com';
  static const Duration _timeout = Duration(seconds: 20);

  /// Authenticate user credentials
  Future<UserModel> login(String username, String password) async {
    final uri = Uri.parse('$_baseUrl/auth/login');
    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': username.trim(),
            'password': password,
            'expiresInMins': 60,
          }),
        )
        .timeout(_timeout);

    final data = _decode(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        data['message']?.toString() ??
            'Login failed. Check the username and password.',
      );
    }

    return UserModel.fromJson(data);
  }

  /// Register a new simulated user account
  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/users/add');
    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
            'username': username,
            'password': password,
            'company': {'name': 'FoodLoop Community'},
          }),
        )
        .timeout(_timeout);

    final data = _decode(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        data['message']?.toString() ?? 'Could not register user.',
      );
    }

    return UserModel.fromJson(data);
  }

  /// Retrieve surplus food / products list
  Future<List<ProductModel>> getProducts() async {
    final uri = Uri.parse('$_baseUrl/products?limit=30');
    final response = await http.get(uri).timeout(_timeout);
    final data = _decode(response);

    if (response.statusCode != 200) {
      throw Exception('Unable to load food listings.');
    }

    final rawList = (data['products'] as List?) ?? [];
    return rawList
        .whereType<Map>()
        .map((item) => ProductModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  /// Retrieve community directory users list
  Future<List<UserModel>> getUsers() async {
    final uri = Uri.parse('$_baseUrl/users?limit=30');
    final response = await http.get(uri).timeout(_timeout);
    final data = _decode(response);

    if (response.statusCode != 200) {
      throw Exception('Unable to load community directory.');
    }

    final rawList = (data['users'] as List?) ?? [];
    return rawList
        .whereType<Map>()
        .map((item) => UserModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Map<String, dynamic> _decode(http.Response response) {
    try {
      final value = jsonDecode(response.body);
      return value is Map<String, dynamic> ? value : <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }
}
