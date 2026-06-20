import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Keranjang"),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.fastfood),
            title: Text("Tahu Tempe"),
            subtitle: Text("Rp10.000"),
            trailing: Text("x1"),
          ),
          ListTile(
            leading: Icon(Icons.fastfood),
            title: Text("Tempe Goreng"),
            subtitle: Text("Rp15.000"),
            trailing: Text("x2"),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: ElevatedButton(
          onPressed: () {},
          child: const Text("Checkout"),
        ),
      ),
    );
  }
}