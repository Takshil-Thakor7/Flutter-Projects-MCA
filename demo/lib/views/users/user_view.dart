import 'package:flutter/material.dart';

import '../../controllers/user_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user_model.dart';

/// View displaying community members directory with search capabilities
class UserView extends StatefulWidget {
  final UserController controller;

  const UserView({super.key, required this.controller});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerUpdated);
  }

  @override
  void didUpdateWidget(covariant UserView oldWidget) {
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
        title: const Text(
          'Community directory',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      child: TextField(
        controller: _searchController,
        onChanged: widget.controller.updateSearchQuery,
        decoration: InputDecoration(
          hintText: 'Search people or email...',
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

    if (controller.errorMessage != null && controller.users.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 40, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                'Could not load users. Check your internet connection.\n${controller.errorMessage}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 14),
              FilledButton.tonal(
                onPressed: () => controller.fetchUsers(),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    final users = controller.filteredUsers;

    if (users.isEmpty) {
      return const Center(
        child: Text(
          'No community members found.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return _buildUserTile(users[index]);
      },
    );
  }

  Widget _buildUserTile(UserModel user) {
    final hasImage = user.image.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primaryLight,
          backgroundImage: hasImage ? NetworkImage(user.image) : null,
          child: !hasImage
              ? Text(
                  user.initial,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )
              : null,
        ),
        title: Text(
          user.fullName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.email.isNotEmpty ? user.email : 'No email available',
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 3),
              Text(
                user.companyName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.person_outline, color: AppColors.primary),
      ),
    );
  }

  Widget _buildFooterNote() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      child: Text(
        'Sample community data from dummyjson.com/users. '
        'These are API demo users, not verified FoodLoop members.',
        style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
        textAlign: TextAlign.center,
      ),
    );
  }
}
