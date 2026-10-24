import 'package:flutter/material.dart';

import '../../controllers/product_controller.dart';
import '../../controllers/user_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user_model.dart';
import '../products/product_view.dart';
import '../users/user_view.dart';

/// Main Dashboard view featuring Home, Food listings, Community directory, and Profile
class DashboardView extends StatefulWidget {
  final UserModel currentUser;

  const DashboardView({super.key, required this.currentUser});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _currentIndex = 0;
  final ProductController _productController = ProductController();
  final UserController _userController = UserController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    _productController.fetchProducts();
    _userController.fetchUsers();
  }

  Future<void> _handleRefresh() async {
    await Future.wait([
      _productController.fetchProducts(),
      _userController.fetchUsers(),
    ]);
  }

  @override
  void dispose() {
    _productController.dispose();
    _userController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _buildHomeTab(),
      ProductView(controller: _productController),
      UserView(controller: _userController),
      _buildProfileTab(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            label: 'Food',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            label: 'Community',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // ==================== HOME TAB ====================

  Widget _buildHomeTab() {
    final firstName = widget.currentUser.firstName.isNotEmpty
        ? widget.currentUser.firstName
        : widget.currentUser.fullName.split(' ').first;

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          _buildAppHeader(),
          const SizedBox(height: 22),
          _buildWelcomeBanner(firstName),
          const SizedBox(height: 24),
          _buildCommunityOverview(),
          const SizedBox(height: 24),
          _buildQuickActions(),
          const SizedBox(height: 20),
          _buildMissionCard(),
        ],
      ),
    );
  }

  Widget _buildAppHeader() {
    return Row(
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.eco, color: Colors.white, size: 29),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FoodLoop',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Rescue food, reduce waste',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _handleRefresh,
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh data',
        ),
      ],
    );
  }

  Widget _buildWelcomeBanner(String firstName) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.volunteer_activism, color: Colors.white, size: 34),
          const SizedBox(height: 14),
          Text(
            'Hello, $firstName!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Rescue surplus food and help it reach people who need it.',
            style: TextStyle(color: Colors.white, height: 1.4),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white70),
            ),
            onPressed: () => setState(() => _currentIndex = 1),
            icon: const Icon(Icons.search),
            label: const Text('Explore food listings'),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your community at a glance',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ListenableBuilder(
                listenable: _productController,
                builder: (context, _) => _buildStatCard(
                  icon: Icons.restaurant,
                  label: 'Food items',
                  count: _productController.products.length,
                  isLoading: _productController.isLoading,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ListenableBuilder(
                listenable: _userController,
                builder: (context, _) => _buildStatCard(
                  icon: Icons.people_alt_outlined,
                  label: 'Community',
                  count: _userController.users.length,
                  isLoading: _userController.isLoading,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required int count,
    required bool isLoading,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 25),
          const SizedBox(height: 12),
          Text(
            isLoading ? '…' : '$count',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick actions',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _buildActionTile(
          icon: Icons.food_bank_outlined,
          title: 'Browse surplus food',
          subtitle: 'Explore sample listings from the products API',
          onTap: () => setState(() => _currentIndex = 1),
        ),
        _buildActionTile(
          icon: Icons.diversity_3_outlined,
          title: 'Find community members',
          subtitle: 'View the sample user directory',
          onTap: () => setState(() => _currentIndex = 2),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: AppColors.surface,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryLight,
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _buildMissionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, color: AppColors.primary),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FoodLoop mission',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Instead of wasting food, make it reach every home and every person who needs it.',
                  style: TextStyle(color: AppColors.textMuted, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== PROFILE TAB ====================

  Widget _buildProfileTab() {
    final user = widget.currentUser;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 20),
        CircleAvatar(
          radius: 42,
          backgroundColor: AppColors.primaryLight,
          backgroundImage: user.image.isNotEmpty
              ? NetworkImage(user.image)
              : null,
          child: user.image.isEmpty
              ? const Icon(Icons.person, color: AppColors.primary, size: 45)
              : null,
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            user.fullName,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (user.email.isNotEmpty)
          Center(
            child: Text(
              user.email,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
        const SizedBox(height: 28),
        const Text(
          'Application details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border),
          ),
          child: const Column(
            children: [
              ListTile(
                leading: Icon(Icons.eco_outlined, color: AppColors.primary),
                title: Text('FoodLoop'),
                subtitle: Text(
                  'Surplus food management and community connection',
                ),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.api, color: AppColors.primary),
                title: Text('API integration'),
                subtitle: Text('DummyJSON Products and Users APIs'),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.lock_outline, color: AppColors.primary),
                title: Text('Demo authentication'),
                subtitle: Text('DummyJSON login and simulated registration'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        FilledButton.tonalIcon(
          onPressed: _showSignOutDialog,
          icon: const Icon(Icons.logout),
          label: const Text('Sign out'),
        ),
      ],
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('Return to the login screen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}
