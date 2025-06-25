import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailVerificationScreen extends StatefulWidget {
  final User user;
  const EmailVerificationScreen({required this.user, Key? key})
    : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;

  @override
  void initState() {
    super.initState();
    checkEmailVerified();
  }

  Future<void> checkEmailVerified() async {
    await widget.user.reload();
    setState(() {
      isEmailVerified = widget.user.emailVerified;
    });
    if (!isEmailVerified) {
      // Yeniden kontrol için bekle veya mail gönder
      Future.delayed(const Duration(seconds: 3), checkEmailVerified);
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      await widget.user.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(const Duration(seconds: 30));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      // hata yönetimi
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('E-posta Doğrulama')),
      body: Center(
        child: isEmailVerified
            ? ElevatedButton(
                onPressed: () {
                  // Email doğrulandıktan sonra ana sayfaya geç
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                child: const Text('Ana Sayfaya Git'),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Lütfen e-posta adresinizi doğrulayın.'),
                  ElevatedButton(
                    onPressed: canResendEmail ? sendVerificationEmail : null,
                    child: const Text('Doğrulama Maili Gönder'),
                  ),
                ],
              ),
      ),
    );
  }
}
