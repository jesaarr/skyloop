import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mirror_me/screens/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _showLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'MirrorMe',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2025 Skyloop Interactive. All rights reserved.',
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'MirrorMe',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.mood),
      children: [
        const Text(
          'MirrorMe, Skyloop Interactive tarafından geliştirilen bir yapay zeka destekli kişisel gelişim uygulamasıdır.',
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            launchUrl(Uri.parse('https://skyloop.dev'));
          },
          child: const Text(
            'Web sitemizi ziyaret et',
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Skyloop Interactive',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Hakkında'),
            onTap: () => _showAboutDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: const Text('Lisanslar'),
            onTap: () => _showLicenses(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Çıkış Yap'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
