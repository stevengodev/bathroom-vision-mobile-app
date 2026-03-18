import 'package:flutter/material.dart';

class MenuHamburguer extends StatelessWidget {
  final VoidCallback? onTap;

  const MenuHamburguer({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: const Icon(Icons.menu, size: 28, color: Colors.black87),
      ),
    );
  }
}
