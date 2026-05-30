import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:warungly/core/auth/auth_service.dart';
import 'package:warungly/core/auth/auth_state.dart';

import 'package:warungly/screen/admin_page.dart';
import 'package:warungly/screen/home_screen.dart';

class SelectRoleScreen extends StatelessWidget {
  const SelectRoleScreen({super.key});

  Future<void> pilihRole(
    BuildContext context,
    String role,
  ) async {
    try {
      final authService = AuthService();

      final authState = Provider.of<AuthState>(
        context,
        listen: false,
      );

      final user = FirebaseAuth.instance.currentUser!;

      final token = (await user.getIdToken())!;

      await authService.selectRole(
        role,
        token,
      );

      await authState.setRole(role);

      if (!context.mounted) return;

      if (role == "admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AdminPage(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Mode"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_outline,
              size: 80,
            ),
            const SizedBox(height: 20),
            const Text(
              "Masuk Sebagai",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shopping_cart),
                label: const Text("Pembeli"),
                onPressed: () {
                  pilihRole(context, "buyer");
                },
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.store),
                label: const Text("Penjual"),
                onPressed: () {
                  pilihRole(context, "admin");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}