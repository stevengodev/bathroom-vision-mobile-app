import 'package:bathroom_vision/features/auth/models/user_response.dart';
import 'package:bathroom_vision/features/auth/presentation/register_user.dart';
import 'package:flutter/material.dart';
import '../../../shared/enums/role.dart';

class UserCard extends StatelessWidget {
  final UserResponse user;

  const UserCard({super.key, required this.user});

  Role _getRoleEnum(String role) {
    return Role.values.firstWhere(
      (r) => r.name == role,
      orElse: () => Role.CLEANER,
    );
  }

  Color _getRoleColor(Role role) {
    switch (role) {
      case Role.MAINTAINER:
        return Colors.green;
      case Role.CLEANER:
        return Colors.orange;
      case Role.ADMIN:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleEnum = _getRoleEnum(user.role);
    final roleColor = _getRoleColor(roleEnum);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            
            CircleAvatar(
              radius: 24,
              child: Text(
                user.name.isNotEmpty
                    ? user.name[0].toUpperCase()
                    : "?",
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 6),

                  
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: roleColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      roleEnum.displayName, // 🔥 AQUÍ EL CAMBIO
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                        bottom:
                            MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: RegisterUser(user: user),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}