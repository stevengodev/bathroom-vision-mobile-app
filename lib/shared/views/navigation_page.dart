import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bathroom_vision/features/auth/models/user_response.dart';
import 'package:bathroom_vision/features/auth/presentation/user_profile_page.dart';
import 'package:bathroom_vision/features/auth/presentation/user_provider.dart';
import 'package:bathroom_vision/features/bathrooms/presentation/bathrooms_page.dart';
import 'package:bathroom_vision/features/blocks/presentation/blocks_page.dart';
import 'package:bathroom_vision/shared/enums/role.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage>
    with SingleTickerProviderStateMixin {
  bool _menuOpen = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    Future.microtask(() async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.loadUserProfile();
    });
  }

  void _toggleMenu() {
    setState(() => _menuOpen = !_menuOpen);
    if (_menuOpen) {
      _controller.forward(from: 0);
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getDescription(String title) {
    switch (title) {
      case "Baños":
        return "Gestiona todos los baños de la institución de forma rápida.";
      case "Bloques":
        return "Administra los bloques y zonas del campus universitario.";
      case "Limpiezas":
        return "Organiza y gestiona los horarios de limpieza general.";
      case "Mis Limpiezas":
        return "Consulta tus horarios asignados y tareas para hoy.";
      case "Usuarios":
        return "Administra los accesos y usuarios activos del sistema.";
      case "Mantenimientos":
        return "Reporta o gestiona reparaciones y mantenimientos.";
      case "Incidencias":
        return "Consulta incidencias reportadas por los usuarios.";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    if (userProvider.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (user == null) {
      return const Scaffold(body: Center(child: Text("No se pudo cargar el usuario")));
    }

    return Scaffold(
      body: Stack(
        children: [
          // FONDO GRADIENTE
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF8FD99F), Color(0xFF6ABF84), Color(0xFF4CB0AF)],
              ),
            ),
          ),

          _buildHome(user),

          if (_menuOpen)
            GestureDetector(
              onTap: _toggleMenu,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(color: Colors.black.withOpacity(0.25)),
              ),
            ),

          if (_menuOpen)
            Center(
              child: ScaleTransition(
                scale: CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
                child: _buildDropdownMenu(user),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdownMenu(UserResponse user) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        // IGUAL AL FONDO DE LOS CUADROS
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFF5F5F5).withOpacity(0.65),
            const Color(0xFFE0E0E0).withOpacity(0.55)
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.white, blurRadius: 20, spreadRadius: 2)],
            ),
            child: const CircleAvatar(
              radius: 35,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white, size: 40),
            ),
          ),
          const SizedBox(height: 10),
          Text("Rol: ${user.role}", style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold)),
          const Divider(height: 30, color: Colors.black12),
          ListTile(
            leading: const Icon(Icons.person, size: 20, color: Colors.black87),
            title: const Text("Ver perfil", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
            onTap: () {
              _toggleMenu();
              Navigator.push(context, MaterialPageRoute(builder: (_) => const UserProfilePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent, size: 20),
            title: const Text("Salir", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            onTap: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
    );
  }

  Widget _buildHome(UserResponse user) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text("BAÑOVISIÓN", 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            
            Center(
              child: Text(
                "Bienvenido, ${user.name}", 
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 15),
            
            GestureDetector(
              onTap: _toggleMenu,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.4), blurRadius: 20)],
                ),
                child: const CircleAvatar(
                  radius: 42, 
                  backgroundColor: Colors.grey, 
                  child: Icon(Icons.person, size: 45, color: Colors.white),
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            Text(
              "Rol: ${user.role}", 
              style: const TextStyle(fontSize: 13, color: Colors.white70, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4, 
                children: [
                  _card(Icons.bathroom, "Baños", Colors.blueAccent, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BathroomsPage()))),
                  if (user.role == Role.ADMIN.name) _card(Icons.grid_view, "Bloques", Colors.purpleAccent, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BlocksPage()))),
                  if (user.role == Role.ADMIN.name) _card(Icons.cleaning_services, "Limpiezas", Colors.orangeAccent, () => Navigator.pushNamed(context, '/horarios-limpiezas')),
                  if (user.role == Role.CLEANER.name) _card(Icons.schedule, "Mis Limpiezas", Colors.purpleAccent, () => Navigator.pushNamed(context, '/horarios-limpiezas/me')),
                  if (user.role == Role.ADMIN.name) _card(Icons.people, "Usuarios", Colors.deepOrangeAccent, () => Navigator.pushNamed(context, '/gestionar-usuarios')),
                  if (user.role == Role.ADMIN.name || user.role == Role.MAINTAINER.name) _card(Icons.build, "Mantenimientos", Colors.tealAccent[700]!, () => Navigator.pushNamed(context, '/mantenimientos')),
                  _card(Icons.report_problem, "Incidencias", Colors.amber, () => Navigator.pushNamed(context, '/incidencias')),
                  if (user.role == Role.ADMIN.name) _card(Icons.analytics, "Analítica", Colors.indigoAccent, () => Navigator.pushNamed(context, '/analiticas')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(IconData icon, String title, Color color, VoidCallback onTap) {
    final description = _getDescription(title);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.85, end: 1),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFFF5F5F5).withOpacity(0.65), const Color(0xFFE0E0E0).withOpacity(0.55)],
                ),
                border: Border.all(color: Colors.white.withOpacity(0.5)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Stack(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withOpacity(0.15),
                          border: Border.all(color: color.withOpacity(0.6), width: 1.5),
                          boxShadow: [
                            BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, spreadRadius: 1),
                          ],
                        ),
                        child: Icon(
                          icon, 
                          size: 32, 
                          color: color,
                          shadows: [
                            Shadow(blurRadius: 4, color: Colors.black.withOpacity(0.2), offset: const Offset(1, 1)),
                          ],
                        ), 
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, 
                              maxLines: 1, 
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                            const SizedBox(height: 2),
                            Text(
                              description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 8.5, color: Colors.black54, height: 1.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Text("➔", 
                      style: TextStyle(fontSize: 14, color: Colors.black38, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}