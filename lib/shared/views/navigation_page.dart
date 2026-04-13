import 'package:bathroom_vision/features/auth/models/user_response.dart';
import 'package:bathroom_vision/features/auth/presentation/user_profile_page.dart';
import 'package:bathroom_vision/features/auth/presentation/user_provider.dart';
import 'package:bathroom_vision/features/bathrooms/presentation/bathrooms_page.dart';
import 'package:bathroom_vision/features/blocks/presentation/blocks_page.dart';
import 'package:bathroom_vision/shared/enums/role.dart';
import 'package:bathroom_vision/shared/widgets/custom_bottom_nav_bar.dart';
import 'package:bathroom_vision/shared/widgets/menu_button.dart';
import 'package:bathroom_vision/shared/widgets/menu_hamburguer.dart';
import 'package:bathroom_vision/shared/widgets/menu_title.dart';
import 'package:bathroom_vision/shared/widgets/user_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.loadUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    if (userProvider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (user == null) {
      return const Center(child: Text("No se pudo cargar el usuario"));
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _buildBody(user),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _handleNavigation(index);
        },
      ),
    );
  }

  Widget _buildBody(UserResponse user) {
    switch (_currentIndex) {
      case 0:
        return _buildMenuContent(user);
      case 1:
        return const BlocksPage();
      case 2:
        return const BathroomsPage();
      case 3:
        return const UserProfilePage();
      default:
        return _buildMenuContent(user);
    }
  }

  Widget _buildMenuContent(UserResponse user) {
    return Container(
      color: const Color(0xFF8FD99F),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserHeader(userName: user.name, role: user.role, isOnline: true),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Botón menú a la izquierda
                  Align(
                    alignment: Alignment.centerLeft,
                    child: MenuHamburguer(
                      onTap: () {
                        print('Menú presionado');
                      },
                    ),
                  ),

                  MenuTitle(title: "BAÑOVISIÓN"),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MenuButton(
                      title: 'Inicio',
                      onTap: () {
                        Navigator.pushNamed(context, '/inicio');
                      },
                    ),
                    MenuButton(
                      title: 'Baños disponibles',
                      onTap: () {
                        Navigator.pushNamed(context, '/banos-disponibles');
                      },
                    ),
                    if (user.role == Role.ADMIN.name)
                      MenuButton(
                        title: 'Horarios de Limpiezas',
                        onTap: () {
                          Navigator.pushNamed(context, '/horarios-limpiezas');
                        },
                      ),
                    if (user.role == Role.CLEANER.name)
                      MenuButton(
                        title: 'Mis horarios de Limpiezas',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/horarios-limpiezas/me',
                          );
                        },
                      ),
                    MenuButton(
                      title: 'Mantenimientos',
                      onTap: () {
                        Navigator.pushNamed(context, '/mantenimientos');
                      },
                    ),
                    MenuButton(
                      title: 'Incidencias',
                      onTap: () {
                        Navigator.pushNamed(context, '/incidencias');
                      },
                    ),
                    MenuButton(
                      title: 'Cerrar sesión',
                      onTap: () {
                        _showLogoutDialog(context);
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(int index) {
    // Metodo para manejar la navegación según el índice seleccionado
    // De momento solo imprime el índice, pero puede que se agregue lógica
    // para navegar a diferentes páginas más adelante
    print('Navegando a índice: $index');
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              print('Sesión cerrada');
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text(
              'Cerrar sesión',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
