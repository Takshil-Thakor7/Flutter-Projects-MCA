import 'package:flutter/material.dart';

import 'core/constants/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'views/auth/login_view.dart';

void main() {
  runApp(const FoodLoopApp());
}

/// Root widget for the FoodLoop application
class FoodLoopApp extends StatelessWidget {
  /// Primary theme color maintained for backwards-compatibility
  static const Color green = AppColors.primary;

  const FoodLoopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodLoop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {'/': (context) => const LoginView()},
    );
  }
}

/// Backwards compatibility alias
typedef MyApp = FoodLoopApp;
