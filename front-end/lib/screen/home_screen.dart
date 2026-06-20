import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  Widget productCard(
    String nama,
    String harga,
    IconData icon,
    BuildContext context,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.orange,
            ),
            const SizedBox(height: 10),
            Text(
              nama,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              harga,
              style: const TextStyle(
                color: Colors.green,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(
                      name: nama,
                      price: harga,
                      icon: icon,
        ),
      ),
    );
  },
  child: const Text("Beli"),
),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Warungly"),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user.photoURL != null)
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(user.photoURL!),
                ),
              ),

            const SizedBox(height: 15),

            Center(
              child: Text(
                "Halo, ${user.displayName ?? "User"} 👋",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 5),

            Center(
              child: Text(
                user.email ?? "",
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Daftar Produk",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  productCard(
                    "Tahu Tempe",
                    "Rp10.000",
                    Icons.fastfood,
                    context,
                  ),
                  productCard(
                    "Tempe Goreng",
                    "Rp12.000",
                    Icons.restaurant,
                    context,
                  ),
                  productCard(
                    "Keripik Tempe",
                    "Rp18.000",
                    Icons.lunch_dining,
                    context,
                  ),
                  productCard(
                    "Tahu Crispy",
                    "Rp15.000",
                    Icons.local_dining,
                    context,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}