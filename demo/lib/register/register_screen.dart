import 'package:flutter/material.dart';

import '../views/auth/register_view.dart';

/// Legacy export wrapper for RegisterView
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegisterView();
  }
}
