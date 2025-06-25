import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Çıkış yapıldı.")));
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("MirrorMe Ana Sayfa"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Text(
          "Hoş geldin ${user?.email ?? 'kullanıcı'} 👑",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
