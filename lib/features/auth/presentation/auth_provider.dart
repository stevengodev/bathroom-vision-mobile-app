import 'package:bathroom_vision/features/auth/data/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {

  final AuthRepository repository;

  AuthProvider(this.repository);

  bool loading = false;
  String? error;
  bool isAuthenticated = false;

  // Login con email y contraseña
  Future<void> login(String email, String password) async {
    try {
      loading = true;
      error = null;
      notifyListeners();

      await repository.login(email, password);
      
      isAuthenticated = true;

    } catch (e) {
      error = e.toString();
      isAuthenticated = false;
    }

    loading = false;
    notifyListeners();
  }

  // Login con Google
  Future<void> loginWithGoogle() async {
    try {
      loading = true;
      error = null;
      notifyListeners();

      await repository.loginWithGoogle();
      
      isAuthenticated = true;

    } catch (e) {
      error = e.toString();
      isAuthenticated = false;
    }

    loading = false;
    notifyListeners();
  }

  // Logout
  Future<void> logout() async {
    await repository.logout();
    isAuthenticated = false;
    notifyListeners();
  }

  // Verificar el estado de autenticación al iniciar la app (opcional pero recomendado)
  Future<void> checkAuthStatus() async {
    try {
      // Verificar si hay un token guardado
      final hasValidToken = await repository.isAuthenticated();
      isAuthenticated = hasValidToken;
      notifyListeners();
    } catch (e) {
      isAuthenticated = false;
      notifyListeners();
    }
  }
}