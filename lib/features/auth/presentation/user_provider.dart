import 'package:bathroom_vision/features/auth/data/user_repository.dart';
import 'package:bathroom_vision/features/auth/models/user_request.dart';
import 'package:bathroom_vision/shared/enums/role.dart';
import 'package:flutter/material.dart';
import 'package:bathroom_vision/features/auth/models/user_response.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository userRepository;

  UserProvider(this.userRepository);

  UserResponse? user;
  List<UserResponse>? users;
  bool loading = false;
  String? error;

  Future<void> loadUserProfile() async {

    if (loading) return;

    loading = true;
    error = null;
    notifyListeners();

    try {
      user = await userRepository.getProfile();
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }

  Future<void> loadUsersByRole(Role role) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      users = await userRepository.getUsersByRole(role);
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }

  Future<void> loadUsersByRoles(List<Role> roles) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      users = await userRepository.getUsersByRoles(roles);
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }

  Future<void> updateUser({
    required int id,
    required UserRequest request,
  }) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final updatedUser = await userRepository.updateUser(
        id: id,
        request: request,
      );

      // Actualizar el usuario en la lista si existe
      if (users != null) {
        final index = users!.indexWhere((u) => u.id == id);
        if (index != -1) {
          users![index] = updatedUser;
        }
      }

      // Si el usuario actualizado es el perfil actual, actualizarlo también
      if (user != null && user!.id == id) {
        user = updatedUser;
      }
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }

}