import 'package:bathroom_vision/features/auth/data/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:bathroom_vision/features/auth/models/user_response.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository userRepository;

  UserProvider(this.userRepository);

  UserResponse? user;
  bool loading = false;
  String? error;

  Future<void> loadUserProfile() async {
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
}