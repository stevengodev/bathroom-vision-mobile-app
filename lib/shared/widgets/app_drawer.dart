import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: 20),

            const Text(
              "BAÑOVISIÓN",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            _MenuButton(
              title: "Inicio",
              onTap: () {},
            ),

            _MenuButton(
              title: "Baños disponibles",
              onTap: () {},
            ),

            _MenuButton(
              title: "Horarios de Limpiezas",
              onTap: () {},
            ),

            _MenuButton(
              title: "Mantenimientos",
              onTap: () {},
            ),

            _MenuButton(
              title: "Incidencias",
              onTap: () {},
            ),

            const Spacer(),

            _MenuButton(
              title: "Cerrar sesión",
              onTap: () {},
            ),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _MenuButton({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              const Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ),
    );
  }
}