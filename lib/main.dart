import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart'; // flutterfire configure sonrası oluşan dosya
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MirrorMeApp());
}

class MirrorMeApp extends StatelessWidget {
  const MirrorMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MirrorMe',
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const LoginScreen();
    } else {
      return const HomeScreen();
    }
  }
}
