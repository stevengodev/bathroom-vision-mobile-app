import 'package:bathroom_vision/features/auth/models/user_response.dart';
import 'package:flutter/material.dart';
import '../../../shared/enums/role.dart';

class UserCard extends StatelessWidget {
  final UserResponse user;
  final VoidCallback? onTap;

  const UserCard({
    super.key,
    required this.user,
    this.onTap,
  });

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

    return InkWell(
      onTap: onTap, // 🔥 navegación aquí
      borderRadius: BorderRadius.circular(16),

      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),

        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [

              /// 🔹 Avatar
              CircleAvatar(
                radius: 24,
                child: Text(
                  user.name.isNotEmpty
                      ? user.name[0].toUpperCase()
                      : "?",
                ),
              ),

              const SizedBox(width: 12),

              /// 🔹 Info
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
                        roleEnum.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// 🔹 Indicador visual (no botón)
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}