import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsTab extends StatefulWidget {
  final bool isDarkMode;
  final void Function(bool) onThemeChanged;

  const SettingsTab({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  final TextEditingController _assistantNameController =
      TextEditingController();
  String _assistantName = "Asistan";

  bool _currentDark = false; // UI'daki switch için local kopya

  @override
  void initState() {
    super.initState();
    _currentDark = widget.isDarkMode;
    _loadAssistantName();
  }

  Future<void> _loadAssistantName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _assistantName = prefs.getString('assistantName') ?? _assistantName;
    });
  }

  Future<void> _saveAssistantName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('assistantName', name);
  }

  void _updateAssistantName() {
    final name = _assistantNameController.text.trim();
    if (name.isEmpty) return;
    _saveAssistantName(name);
    setState(() => _assistantName = name);
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // Temadan gelsin: tüm app ile uyumlu
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Ayarlar'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Üst başlık: her zaman mavi arka plan
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: Colors.blueAccent.shade100,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    'MirrorMe',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '“Your Digital Twin”',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            _sectionTitle(context, 'Kişiselleştirme Ayarları'),
            const SizedBox(height: 20),

            _tile(
              context: context,
              icon: Icons.edit,
              title: 'Asistan İsmi',
              subtitle: _assistantName,
              onTap: _showNameDialog,
            ),

            _tile(
              context: context,
              icon: Icons.color_lens,
              title: 'Tema Seçimi',
              subtitle: _currentDark ? 'Karanlık Mod' : 'Açık Mod',
              onTap: () {
                final next = !_currentDark;
                setState(() => _currentDark = next);
                widget.onThemeChanged(next); // tüm app'in temasını değiştir
              },
            ),

            const SizedBox(height: 30),
            _sectionTitle(context, 'Diğer Ayarlar'),
            const SizedBox(height: 20),

            _tile(
              context: context,
              icon: Icons.logout,
              title: 'Çıkış Yap',
              subtitle: '',
              onTap: () => _logout(context),
              isRed: true,
            ),

            const SizedBox(height: 50),
            Text(
              '© 2025 Skyloop Interactive',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: theme.textTheme.bodyLarge?.color,
      ),
    );
  }

  Widget _tile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isRed = false,
  }) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: isRed
              ? Colors.red.shade200
              : (isDark ? Colors.grey.shade800 : theme.cardColor),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 32,
              color: isRed
                  ? Colors.white
                  : (isDark ? Colors.white : Colors.blueAccent),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isRed
                          ? Colors.white
                          : theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  if (subtitle != null && subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(
                          0.7,
                        ),
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: isRed
                  ? Colors.white
                  : theme.iconTheme.color?.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }

  void _showNameDialog() {
    _assistantNameController.text = _assistantName;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Asistan İsmini Değiştir'),
          content: TextField(
            controller: _assistantNameController,
            decoration: const InputDecoration(hintText: 'Yeni ismi girin'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () {
                _updateAssistantName();
                Navigator.of(context).pop();
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }
}
