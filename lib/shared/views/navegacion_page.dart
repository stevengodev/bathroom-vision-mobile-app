import 'package:bathroom_vision/shared/widgets/custom_bottom_nav_bar.dart';
import 'package:bathroom_vision/shared/widgets/menu_button.dart';
import 'package:bathroom_vision/shared/widgets/menu_hamburguer.dart';
import 'package:bathroom_vision/shared/widgets/menu_title.dart';
import 'package:bathroom_vision/shared/widgets/user_header.dart';
import 'package:flutter/material.dart';

class NavigacionPage extends StatefulWidget {
  const NavigacionPage({super.key});

  @override
  State<NavigacionPage> createState() => _NavigacionPageState();
}

class _NavigacionPageState extends State<NavigacionPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _buildBody(),
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

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildMenuContent();
      case 1:
        return _buildPlaceholder('BLOQUES');
      case 2:
        return _buildPlaceholder('BAÑOS');
      case 3:
        return _buildPlaceholder('PERFIL');
      default:
        return _buildMenuContent();
    }
  }

  Widget _buildMenuContent() {
    return Container(
      color: const Color(0xFF8FD99F),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con avatar y nombre de usuario
            const UserHeader(
              userName: 'Mateo López',
              role: 'Usuario',
              isOnline: true,
            ),

            // Fila con menú hamburguesa y título
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

                  // Título centrado REAL
                  MenuTitle(title: "BAÑOVISIÓN"),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Lista de opciones del menú
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
                    MenuButton(
                      title: 'Horarios de Limpiezas',
                      onTap: () {
                        Navigator.pushNamed(context, '/horarios-limpiezas');
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

  Widget _buildPlaceholder(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Esta sección está en construcción',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
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
