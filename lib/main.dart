import 'package:flutter/material.dart';

void main() {
  runApp(const MirrorMeApp());
}

class MirrorMeApp extends StatelessWidget {
  const MirrorMeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MirrorMe',
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MirrorMe Giriş'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Buraya giriş sonrası işlem koyacağız
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Giriş Butonuna Basıldı!')),
            );
          },
          child: const Text('Giriş Yap'),
        ),
      ),
    );
  }
}
