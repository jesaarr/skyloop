import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mirror_me/services/auth_service.dart'; // Google Sign-In fonksiyonları burda

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  // Normal Email/Şifre ile giriş
  Future<void> _loginWithEmail() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Giriş başarılı!')));
      // TODO: Ana ekrana yönlendirme
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Hata: ${e.message}')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Şifre sıfırlama
  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen önce e-posta girin')),
      );
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şifre sıfırlama maili gönderildi')),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Hata: ${e.message}')));
    }
  }

  // Google ile giriş
  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);
    final userCredential = await AuthService.signInWithGoogle();
    setState(() => _isLoading = false);

    if (userCredential != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google ile giriş başarılı!')),
      );
      // TODO: Ana ekrana yönlendirme
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google ile giriş başarısız')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MirrorMe Giriş')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
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
                const SizedBox(height: 32),
                _isLoading
                    ? const CircularProgressIndicator()
                    : Column(
                        children: [
                          ElevatedButton(
                            onPressed: _loginWithEmail,
                            child: const Text('Giriş Yap'),
                          ),
                          TextButton(
                            onPressed: _resetPassword,
                            child: const Text('Şifremi Unuttum'),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: _loginWithGoogle,
                            icon: const Icon(Icons.login),
                            label: const Text('Google ile Giriş Yap'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
