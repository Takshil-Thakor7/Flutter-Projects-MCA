import 'package:flutter/material.dart';

import '../../controllers/product_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../models/product_model.dart';

/// View displaying available surplus food items with search and filtering
class ProductView extends StatefulWidget {
  final ProductController controller;

  const ProductView({super.key, required this.controller});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerUpdated);
  }

  @override
  void didUpdateWidget(covariant ProductView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerUpdated);
      widget.controller.addListener(_onControllerUpdated);
    }
  }

  void _onControllerUpdated() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerUpdated);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surplus Food Explorer'),
        actions: [
          IconButton(
            onPressed: () {
              _searchController.clear();
              widget.controller.clearSearch();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Clear search',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildContent()),
          _buildFooterNote(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
      child: TextField(
        controller: _searchController,
        onChanged: widget.controller.updateSearchQuery,
        decoration: InputDecoration(
          hintText: 'Search food items...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    widget.controller.clearSearch();
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildContent() {
    final controller = widget.controller;

    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage != null && controller.products.isEmpty) {
      return _buildErrorState(controller.errorMessage!);
    }

    final items = controller.filteredProducts;

    if (items.isEmpty) {
      return const Center(
        child: Text(
          'No matching items found.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildProductCard(items[index]);
      },
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: product.thumbnail.isNotEmpty
                  ? Image.network(
                      product.thumbnail,
                      width: 100,
                      height: 105,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.formattedCategory,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          product.displayPrice,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.ratingStar,
                        size: 17,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        product.rating > 0
                            ? product.rating.toStringAsFixed(1)
                            : '—',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 100,
      height: 105,
      color: AppColors.primaryLight,
      child: const Icon(Icons.restaurant, color: AppColors.primary, size: 35),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_outlined,
              size: 42,
              color: AppColors.primary,
            ),
            const SizedBox(height: 12),
            const Text(
              'Could not load food listings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check your internet connection and try again.\n$error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () => widget.controller.fetchProducts(),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterNote() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      child: Text(
        'Sample data from dummyjson.com/products. These are demo products, not verified surplus food.',
        style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
        textAlign: TextAlign.center,
      ),
    );
  }
}
