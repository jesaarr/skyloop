import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Firebase Console'dan indirilen otomatik dosya

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      appBar: AppBar(title: const Text('MirrorMe Giriş')),
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
