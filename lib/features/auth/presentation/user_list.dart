import 'package:bathroom_vision/features/auth/models/user_response.dart';
import 'package:flutter/material.dart';
import 'user_card.dart';

class UserList extends StatelessWidget {
  final List<UserResponse> users;

  const UserList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return UserCard(user: users[index]);
      },
    );
  }
}