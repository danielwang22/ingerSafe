import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  final Map<String, String> _displayToLanguageKey = const {
    'English': 'English',
    '繁體中文': 'Traditional_Chinese',
    '日本語': 'Japanese',
    '한국어': 'Korean',
  };

  Future<void> _selectLanguage(BuildContext context, String displayLanguage) async {
    final langKey = _displayToLanguageKey[displayLanguage];
    if (langKey == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', langKey);
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Language')),
      body: ListView(
        children: _displayToLanguageKey.keys.map((displayLanguage) {
          return ListTile(
            title: Text(displayLanguage),
            onTap: () => _selectLanguage(context, displayLanguage),
          );
        }).toList(),
      ),
    );
  }
}
