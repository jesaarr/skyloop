import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/auth_wrapper.dart';
import 'screens/settings_tab.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;

  runApp(MirrorMeApp(initialDarkMode: isDarkMode));
}

class MirrorMeApp extends StatefulWidget {
  final bool initialDarkMode;
  const MirrorMeApp({super.key, required this.initialDarkMode});

  @override
  State<MirrorMeApp> createState() => _MirrorMeAppState();
}

class _MirrorMeAppState extends State<MirrorMeApp> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.initialDarkMode;
  }

  Future<void> onThemeChanged(bool value) async {
    setState(() => isDarkMode = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MirrorMe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // AuthWrapper'ı parametrelerle başlatıyoruz
      home: AuthWrapper(onThemeChanged: onThemeChanged, isDarkMode: isDarkMode),
      // İstersen doğrudan /settings route'u da kullanabilirsin
      routes: {
        '/settings': (context) =>
            SettingsTab(onThemeChanged: onThemeChanged, isDarkMode: isDarkMode),
      },
    );
  }
}
