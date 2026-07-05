import 'package:bathroom_vision/shared/widgets/google_login_button.dart';
import 'package:bathroom_vision/shared/widgets/error_flash_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (mounted && authProvider.isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/navegacion');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authProvider.error != null) {
        ErrorFlashCard.error(
          context,
          message: authProvider.error!,
          actionLabel: 'Reintentar',
          onAction: () => _handleLogin(),
        );
        authProvider.error = null;
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            30,
            40,
            30,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "BAÑOVISIÓN",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Image.asset(
                  "assets/images/bathroom.png",
                  height: 120,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Ingresa tu correo electrónico\npara iniciar en esta aplicación",
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "correo@cecar.edu.co",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    return AuthProvider.validateInstitutionalEmail(value);
                  },
                  enabled: !authProvider.loading,
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "contraseña",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu contraseña';
                    }
                    if (value.length < 6) {
                      return 'Mínimo 6 caracteres';
                    }
                    return null;
                  },
                  enabled: !authProvider.loading,
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: authProvider.loading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    ).copyWith(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (states) {
                          if (states.contains(WidgetState.pressed)) {
                            return const Color.fromARGB(255, 2, 150, 51); // color al presionar
                          }
                          return const Color(0xFF8FD99F); // color normal
                        },
                      ),
                    ),
                    child: authProvider.loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            "Continuar",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text("o"),

                const SizedBox(height: 20),

                const GoogleLoginButton(),

                if (authProvider.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      authProvider.error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/register');
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "¿No tienes cuenta? ",
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Regístrate",
                          style: TextStyle(
                            color: Color(0xFF8FD99F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Al hacer clic en continuar aceptas nuestros\nTérminos de servicio y Política de privacidad",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}