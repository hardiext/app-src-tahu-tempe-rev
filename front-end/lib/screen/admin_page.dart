import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warungly/screen/login_screen.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();

  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  if (!context.mounted) return;

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => const LoginScreen(),
    ),
    (route) => false,
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.people),
                title: const Text("Kelola User"),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.fastfood),
                title: const Text("Kelola Menu"),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.receipt_long),
                title: const Text("Kelola Pesanan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}