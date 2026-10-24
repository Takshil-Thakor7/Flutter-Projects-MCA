import '../services/api_service.dart';

/// Legacy adapter for ApiServices to ensure backward compatibility
class ApiServices {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> login(String username, String password) async {
    final user = await _apiService.login(username, password);
    return user.toJson();
  }

  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String password,
  }) async {
    final user = await _apiService.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      username: username,
      password: password,
    );
    return user.toJson();
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final products = await _apiService.getProducts();
    return products.map((p) => p.toJson()).toList();
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final users = await _apiService.getUsers();
    return users.map((u) => u.toJson()).toList();
  }
}
