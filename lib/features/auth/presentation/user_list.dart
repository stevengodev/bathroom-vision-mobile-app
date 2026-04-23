import 'package:bathroom_vision/features/auth/models/user_response.dart';
import 'package:flutter/material.dart';
import 'user_card.dart';

class UserList extends StatelessWidget {
  final List<UserResponse> users;
  final Function(UserResponse user) onTap; // 🔥 nuevo

  const UserList({
    super.key,
    required this.users,
    required this.onTap, // 🔥 requerido
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];

        return UserCard(
          user: user,
          onTap: () => onTap(user), // 🔥 conexión
        );
      },
    );
  }
}