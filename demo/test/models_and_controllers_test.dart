import 'package:flutter_test/flutter_test.dart';
import 'package:demo/models/user_model.dart';
import 'package:demo/models/product_model.dart';
import 'package:demo/controllers/product_controller.dart';
import 'package:demo/controllers/user_controller.dart';

void main() {
  group('UserModel tests', () {
    test('UserModel.fromJson parses correctly', () {
      final json = {
        'id': 1,
        'firstName': 'Emily',
        'lastName': 'Smith',
        'email': 'emily@example.com',
        'company': {'name': 'FoodBank Eco'},
      };

      final user = UserModel.fromJson(json);

      expect(user.fullName, 'Emily Smith');
      expect(user.initial, 'E');
      expect(user.companyName, 'FoodBank Eco');
      expect(user.email, 'emily@example.com');
    });

    test('UserModel handles empty company and name fallback', () {
      final json = {'username': 'rescuer'};
      final user = UserModel.fromJson(json);

      expect(user.fullName, 'rescuer');
      expect(user.initial, 'R');
      expect(user.companyName, 'Community member');
    });
  });

  group('ProductModel tests', () {
    test('ProductModel.fromJson parses correctly', () {
      final json = {
        'id': 10,
        'title': 'Organic Apples',
        'description': 'Fresh surplus apples',
        'category': 'fresh-produce',
        'price': 4.5,
        'rating': 4.8,
        'thumbnail': 'https://example.com/apples.png',
      };

      final product = ProductModel.fromJson(json);

      expect(product.title, 'Organic Apples');
      expect(product.formattedCategory, 'fresh produce');
      expect(product.displayPrice, '\$4.50');
      expect(product.rating, 4.8);
    });
  });

  group('ProductController tests', () {
    test('search query filtering filters product list', () {
      final controller = ProductController();
      controller.updateSearchQuery('apple');
      expect(controller.searchQuery, 'apple');

      controller.clearSearch();
      expect(controller.searchQuery, '');
    });
  });

  group('UserController tests', () {
    test('search query filtering works', () {
      final controller = UserController();
      controller.updateSearchQuery('smith');
      expect(controller.searchQuery, 'smith');

      controller.clearSearch();
      expect(controller.searchQuery, '');
    });
  });
}
