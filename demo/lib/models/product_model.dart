/// Model representing a surplus food / product listing
class ProductModel {
  final int? id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double rating;
  final String thumbnail;

  const ProductModel({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.thumbnail,
  });

  /// User-friendly category name with hyphens replaced
  String get formattedCategory {
    if (category.isEmpty) return 'General';
    return category.replaceAll('-', ' ');
  }

  /// Price display string
  String get displayPrice =>
      '\$${price.toStringAsFixed(price.truncateToDouble() == price ? 0 : 2)}';

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? ''),
      title: (json['title'] ?? 'Food item').toString(),
      description: (json['description'] ?? '').toString(),
      category: (json['category'] ?? 'General').toString(),
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      rating: (json['rating'] is num)
          ? (json['rating'] as num).toDouble()
          : 0.0,
      thumbnail: (json['thumbnail'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'rating': rating,
      'thumbnail': thumbnail,
    };
  }
}
