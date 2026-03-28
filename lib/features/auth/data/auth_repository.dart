import 'package:bathroom_vision/core/storage/secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_api.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthRepository {

  final AuthApi authApi;
  final SecureStorage storage;

  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId: dotenv.env["CLIENT_ID_WEB"]!,
  );

  AuthRepository(this.authApi, this.storage);

  Future<void> register(String name, String email, String password) async {
    await authApi.register(name, email, password);
  }

  Future<void> login(String email, String password) async {
    final jwt = await authApi.login(email, password);
    await storage.saveToken(jwt);
  }

  Future<void> loginWithGoogle() async {

    await googleSignIn.signOut();

    final account = await googleSignIn.signIn();

    if (account == null) {
      throw Exception("Login cancelado");
    }

    final auth = await account.authentication;

    final idToken = auth.idToken;

    if (idToken == null) {
      throw Exception("No se obtuvo idToken");
    }

    final jwt = await authApi.loginWithGoogle(idToken);

    await storage.saveToken(jwt);
  }

  Future<bool> isAuthenticated() async {
    try {
      final token = await storage.getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await googleSignIn.signOut();
    await storage.deleteToken();
  }
}