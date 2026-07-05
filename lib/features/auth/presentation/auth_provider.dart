import 'package:bathroom_vision/features/auth/data/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository repository;

  AuthProvider(this.repository);

  bool loading = false;
  String? error;
  bool isAuthenticated = false;

  static const String allowedEmailDomain = 'cecar.edu.co';

  static bool isValidInstitutionalEmail(String email) {
    final normalizedEmail = email.trim().toLowerCase();
    final pattern = RegExp(r'^[a-z0-9._%+-]+@cecar\.edu\.co$');
    return pattern.hasMatch(normalizedEmail);
  }

  static String? validateInstitutionalEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingresa tu correo';
    }

    if (!isValidInstitutionalEmail(value)) {
      return 'Solo se permiten correos terminados en @cecar.edu.co';
    }

    return null;
  }

  Future<void> register(String name, String email, String password, String role) async {
    if (!isValidInstitutionalEmail(email)) {
      error = 'Solo se permiten correos terminados en @cecar.edu.co';
      notifyListeners();
      return;
    }

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
    if (!isValidInstitutionalEmail(email)) {
      error = 'Solo se permiten correos terminados en @cecar.edu.co';
      isAuthenticated = false;
      notifyListeners();
      return;
    }

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
