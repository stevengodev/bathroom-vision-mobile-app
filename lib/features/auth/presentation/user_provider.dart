import 'package:bathroom_vision/features/auth/data/user_repository.dart';
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
}