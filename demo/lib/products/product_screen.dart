import 'package:flutter/material.dart';

import '../controllers/product_controller.dart';
import '../views/products/product_view.dart';

/// Legacy export wrapper for ProductView
class ProductScreen extends StatefulWidget {
  final Future<List<Map<String, dynamic>>>? future;

  const ProductScreen({super.key, this.future});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductController _controller = ProductController();

  @override
  void initState() {
    super.initState();
    _controller.fetchProducts();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProductView(controller: _controller);
  }
}
