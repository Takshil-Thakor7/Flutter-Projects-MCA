import 'package:flutter/material.dart';

import '../controllers/user_controller.dart';
import '../views/users/user_view.dart';

/// Legacy export wrapper for UserView
class UserScreen extends StatefulWidget {
  final Future<List<Map<String, dynamic>>>? future;

  const UserScreen({super.key, this.future});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final UserController _controller = UserController();

  @override
  void initState() {
    super.initState();
    _controller.fetchUsers();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UserView(controller: _controller);
  }
}
