import 'package:flutter/material.dart';

import '../views/auth/login_view.dart';

/// Legacy export wrapper for LoginView
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginView();
  }
}
