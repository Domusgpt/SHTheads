import 'package:flutter/material.dart';

enum UserRole {
  tradesman,
  admin,
  unauthenticated
}

class AuthProvider extends ChangeNotifier {
  UserRole _role = UserRole.unauthenticated;

  UserRole get role => _role;
  bool get isAuthenticated => _role != UserRole.unauthenticated;

  // Mock sign in for today. Tomorrow this will use Firebase Auth.
  Future<void> signIn(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'admin@shtheads.com') {
      _role = UserRole.admin;
    } else {
      _role = UserRole.tradesman;
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    _role = UserRole.unauthenticated;
    notifyListeners();
  }
}
