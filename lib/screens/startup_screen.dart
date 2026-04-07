import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSelected = prefs.getBool('language_selected') ?? false;

    if (!mounted) return;

    if (hasSelected) {
      Navigator.pushReplacementNamed(context, '/reports');
    } else {
      Navigator.pushReplacementNamed(context, '/select-language');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/icon/logo.png',
          width: 120,
          height: 120,
        ),
      ),
    );
  }
}
