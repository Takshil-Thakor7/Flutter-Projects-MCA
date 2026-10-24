import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../views/dashboard/dashboard_view.dart';

/// Legacy export wrapper for DashboardView
class DashboardScreen extends StatelessWidget {
  final String userName;
  final String userEmail;

  const DashboardScreen({
    super.key,
    this.userName = 'FoodLoop User',
    this.userEmail = '',
  });

  @override
  Widget build(BuildContext context) {
    final parts = userName.split(' ');
    final first = parts.isNotEmpty ? parts.first : 'FoodLoop';
    final last = parts.length > 1 ? parts.sublist(1).join(' ') : 'User';

    return DashboardView(
      currentUser: UserModel(
        firstName: first,
        lastName: last,
        email: userEmail,
      ),
    );
  }
}
