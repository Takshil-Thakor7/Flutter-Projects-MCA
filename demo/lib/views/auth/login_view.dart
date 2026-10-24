import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../core/constants/app_colors.dart';
import '../dashboard/dashboard_view.dart';
import 'register_view.dart';

/// Login view for authenticating FoodLoop users
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'emilys');
  final _passwordController = TextEditingController(text: 'emilyspass');
  final _authController = AuthController();

  bool _hidePassword = true;

  @override
  void initState() {
    super.initState();
    _authController.addListener(_onAuthStateChanged);
  }

  void _onAuthStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _authController.removeListener(_onAuthStateChanged);
    _authController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final user = await _authController.login(
      _usernameController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => DashboardView(currentUser: user)),
      );
    } else if (_authController.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authController.errorMessage!),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLogo(),
                    const SizedBox(height: 22),
                    _buildHeader(),
                    const SizedBox(height: 30),
                    _buildFormFields(),
                    const SizedBox(height: 20),
                    _buildSubmitButton(),
                    const SizedBox(height: 18),
                    _buildRegisterPrompt(),
                    const SizedBox(height: 20),
                    _buildDemoCredentialsInfo(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 82,
        width: 82,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(25),
        ),
        child: const Icon(Icons.eco_rounded, color: Colors.white, size: 46),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to FoodLoop',
          style: TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Rescue food. Support people. Reduce waste.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
        ),
        SizedBox(height: 24),
        Text(
          'Sign in',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: _usernameController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Username',
            prefixIcon: Icon(Icons.person_outline),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Enter your username';
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _passwordController,
          obscureText: _hidePassword,
          onFieldSubmitted: (_) {
            if (!_authController.isLoading) _handleLogin();
          },
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _hidePassword = !_hidePassword;
                });
              },
              icon: Icon(
                _hidePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Enter your password';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    final loading = _authController.isLoading;
    return SizedBox(
      height: 52,
      child: FilledButton.icon(
        onPressed: loading ? null : _handleLogin,
        icon: loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.login),
        label: Text(loading ? 'Signing in...' : 'Login'),
      ),
    );
  }

  Widget _buildRegisterPrompt() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text(
          'New to FoodLoop? ',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterView()),
            );
          },
          child: const Text('Create account'),
        ),
      ],
    );
  }

  Widget _buildDemoCredentialsInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Demo login credentials',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Username: emilys\nPassword: emilyspass',
            style: TextStyle(height: 1.4),
          ),
          SizedBox(height: 6),
          Text(
            'Authentication uses the DummyJSON demo API.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
