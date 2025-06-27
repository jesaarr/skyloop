import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _launchLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'MirrorMe',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2025 Skyloop Interactive',
    );
  }

  void _launchSkyloopWebsite() async {
    const url = 'https://skyloopinteractive.com';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'URL açılamıyor: $url';
    }
  }

  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(color: Colors.black54))
            : null,
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.deepPurple,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              'Skyloop Interactive',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Divider(thickness: 2),
          ),
          _buildListTile(
            context: context,
            icon: Icons.language,
            title: 'Dil Değiştir (Şimdilik devre dışı)',
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Çok yakında...')));
            },
          ),
          _buildListTile(
            context: context,
            icon: Icons.link,
            title: 'Skyloop Web Sitesi',
            onTap: _launchSkyloopWebsite,
          ),
          _buildListTile(
            context: context,
            icon: Icons.info_outline,
            title: 'Lisanslar',
            onTap: () => _launchLicenses(context),
          ),
          _buildListTile(
            context: context,
            icon: Icons.logout,
            title: 'Çıkış Yap',
            onTap: () => _logout(context),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              '© 2025 Skyloop Interactive',
              style: TextStyle(
                color: Colors.deepPurple.shade200,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
