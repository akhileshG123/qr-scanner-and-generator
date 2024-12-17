import 'package:flutter/material.dart';
import 'package:qr_scanner/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _darkMode = false;

  // Function to toggle dark mode
  void _toggleDarkMode(bool isDarkMode) {
    setState(() {
      _darkMode = isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: _darkMode
              ? Brightness.dark
              : Brightness.light, // Sets brightness based on dark mode
        ),
        useMaterial3: true,
      ),
      home: HomePage(onThemeChanged: _toggleDarkMode),
    );
  }
}
