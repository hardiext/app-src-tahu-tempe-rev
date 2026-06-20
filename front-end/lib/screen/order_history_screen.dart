import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F5FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF66BB6A),
        title: const Text(
          "Riwayat Pesanan",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              title: const Text("Tahu Tempe"),
              subtitle: const Text("10 Juni 2026"),
              trailing: const Text(
                "Selesai",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.local_shipping,
                color: Colors.orange,
              ),
              title: const Text("Keripik Tempe"),
              subtitle: const Text("15 Juni 2026"),
              trailing: const Text(
                "Diproses",
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ),
        ],
      ),
    );
  }
}