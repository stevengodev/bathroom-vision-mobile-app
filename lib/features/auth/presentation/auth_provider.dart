import 'package:bathroom_vision/features/auth/data/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository repository;

  AuthProvider(this.repository);

  bool loading = false;
  String? error;
  bool isAuthenticated = false;

  Future<void> register(String name, String email, String password, String role) async {
    loading = true;
    notifyListeners();

    try {
      await repository.register(name, email, password, role);

      isAuthenticated = true;
      error = null;
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

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

  Future<void> logout() async {
    await repository.logout();
    isAuthenticated = false;
    notifyListeners();
  }


  Future<void> checkAuthStatus() async {
    try {
      
      final hasValidToken = await repository.isAuthenticated();
      isAuthenticated = hasValidToken;
      notifyListeners();
    } catch (e) {
      isAuthenticated = false;
      notifyListeners();
    }
  }
}
