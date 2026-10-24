import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../core/constants/app_colors.dart';

/// Registration view for creating a new FoodLoop account
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final user = await _authController.register(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (user != null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Registration submitted'),
          content: Text(
            'Welcome to FoodLoop, ${user.firstName.isNotEmpty ? user.firstName : _firstNameController.text.trim()}! '
            'The DummyJSON demo API accepted the registration request. '
            'Its sample data is simulated and is not permanently saved by the service.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text('Back to login'),
            ),
          ],
        ),
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
      appBar: AppBar(
        title: const Text('Create account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildNameFields(),
                    const SizedBox(height: 14),
                    _buildEmailField(),
                    const SizedBox(height: 14),
                    _buildUsernameField(),
                    const SizedBox(height: 14),
                    _buildPasswordField(),
                    const SizedBox(height: 22),
                    _buildSubmitButton(),
                    const SizedBox(height: 12),
                    _buildDemoDisclaimer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 68,
          width: 68,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.person_add_alt_1,
            color: Colors.white,
            size: 34,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Join the FoodLoop community',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Create an account to help make surplus food useful.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildNameFields() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _firstNameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'First name'),
            validator: (value) =>
                value == null || value.trim().isEmpty ? 'Required' : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: _lastNameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Last name'),
            validator: (value) =>
                value == null || value.trim().isEmpty ? 'Required' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Email address',
        prefixIcon: Icon(Icons.email_outlined),
      ),
      validator: (value) {
        if (value == null ||
            !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Choose a username',
        prefixIcon: Icon(Icons.person_outline),
      ),
      validator: (value) {
        if (value == null || value.trim().length < 3) {
          return 'Use at least 3 characters';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _hidePassword,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          onPressed: () => setState(() => _hidePassword = !_hidePassword),
          icon: Icon(
            _hidePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.length < 6) {
          return 'Use at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    final loading = _authController.isLoading;
    return SizedBox(
      height: 52,
      child: FilledButton(
        onPressed: loading ? null : _handleRegister,
        child: loading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text('Register'),
      ),
    );
  }

  Widget _buildDemoDisclaimer() {
    return const Text(
      'Note: DummyJSON simulates registration responses for testing; '
      'it does not create a permanent account.',
      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
    );
  }
}
