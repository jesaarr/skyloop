import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart'; // flutterfire configure sonrası oluşan dosya

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
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _showMessage(String text) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _loginWithEmail() async {
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      _showMessage('Giriş başarılı!');
      // TODO: Ana sayfaya yönlendir
    } on FirebaseAuthException catch (e) {
      _showMessage('Giriş hatası: ${e.message}');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _registerWithEmail() async {
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      _showMessage('Kayıt başarılı! Giriş yapabilirsiniz.');
      // İstersen direk giriş yaptırabiliriz buradan
    } on FirebaseAuthException catch (e) {
      _showMessage('Kayıt hatası: ${e.message}');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _resetPassword() async {
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      _showMessage('Şifre sıfırlama maili gönderildi.');
    } on FirebaseAuthException catch (e) {
      _showMessage('Şifre sıfırlama hatası: ${e.message}');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _loading = true);
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        _showMessage('Google giriş işlemi iptal edildi.');
        setState(() => _loading = false);
        return;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      _showMessage('Google ile giriş başarılı!');
      // TODO: Ana sayfaya yönlendir
    } catch (e) {
      _showMessage('Google ile giriş hatası: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MirrorMe Giriş')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-posta'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            if (_loading) const CircularProgressIndicator(),
            if (!_loading) ...[
              ElevatedButton(
                onPressed: _loginWithEmail,
                child: const Text('Giriş Yap'),
              ),
              ElevatedButton(
                onPressed: _registerWithEmail,
                child: const Text('Kayıt Ol'),
              ),
              TextButton(
                onPressed: _resetPassword,
                child: const Text('Şifremi Unuttum'),
              ),
              const Divider(),
              ElevatedButton.icon(
                icon: Image.asset('assets/google_logo.png', height: 24),
                label: const Text('Google ile Giriş Yap'),
                onPressed: _signInWithGoogle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
