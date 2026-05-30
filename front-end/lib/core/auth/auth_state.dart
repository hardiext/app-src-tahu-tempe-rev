import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState extends ChangeNotifier {
  User? user;
  String? role;
  bool isLoading = true;

  bool get isLoggedIn {
    return user != null && user!.emailVerified;
  }

  Future init() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      role = prefs.getString("role");

      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        await currentUser.reload();

        user = FirebaseAuth.instance.currentUser;
      }

      isLoading = false;
      notifyListeners();

      FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
        if (firebaseUser != null) {
          await firebaseUser.reload();

          user = FirebaseAuth.instance.currentUser;
        } else {
          user = null;
        }

        isLoading = false;

        notifyListeners();
      });
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  void setGoogleLogin(User newUser, Map backendData) async {
    user = newUser;
    role = backendData["role"] ?? "customer";

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("role", role!);

    isLoading = false;

    notifyListeners();
  }
  Future<void> setRole(String newRole) async {
    role = newRole;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("role", newRole);

    notifyListeners();
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();

    user = null;
    role = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }
}
