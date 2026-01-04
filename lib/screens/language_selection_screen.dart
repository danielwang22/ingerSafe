import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  final Map<String, String> _displayToLanguageKey = const {
    'English': 'English',
    '繁體中文': 'Traditional_Chinese',
    '日本語': 'Japanese',
    '한국어': 'Korean',
    'ไทย': 'Thai',
    'Tiếng Việt': 'Vietnamese',
  };

  Future<void> _selectLanguage(String displayLanguage) async {
    final langKey = _displayToLanguageKey[displayLanguage];
    if (langKey == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', langKey);

    // 在異步操作後檢查 mounted 狀態
    if (!mounted) return;
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
            onTap: () => _selectLanguage(displayLanguage),
          );
        }).toList(),
      ),
    );
  }
}
