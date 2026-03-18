import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bathroom_vision/features/auth/presentation/auth_provider.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key});

  Future<void> _handleGoogleLogin(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();

    try {



      // Intentar hacer login con Google
      await authProvider.loginWithGoogle();

      // Si el login es exitoso, navegar a la página de navegación
      if (context.mounted && authProvider.isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/navegacion');
      }
    } catch (e) {
      // El error ya se maneja en el AuthProvider
      // Mostrar SnackBar adicional si es necesario
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al iniciar sesión con Google: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: authProvider.loading ? null : () => _handleGoogleLogin(context),
        icon: authProvider.loading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Image.asset(
                'assets/images/google_logo.png',
                height: 24,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.login, color: Colors.red);
                },
              ),
        label: Text(
          authProvider.loading ? "Iniciando sesión..." : "Continuar con Google",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: Colors.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}