import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../services/api_service.dart';

/// Controller handling surplus food listings and search filtering
class ProductController extends ChangeNotifier {
  final ApiService _apiService;

  ProductController({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  /// Returns products matching the current search query
  List<ProductModel> get filteredProducts {
    if (_searchQuery.isEmpty) return _products;

    final lower = _searchQuery.toLowerCase();
    return _products.where((product) {
      final titleMatch = product.title.toLowerCase().contains(lower);
      final categoryMatch = product.category.toLowerCase().contains(lower);
      final descMatch = product.description.toLowerCase().contains(lower);
      return titleMatch || categoryMatch || descMatch;
    }).toList();
  }

  /// Fetch products from the API
  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _apiService.getProducts();
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
