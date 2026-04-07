import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageNotifier extends AsyncNotifier<String> {
  static const _key = 'selected_language';

  @override
  Future<String> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ?? 'Traditional_Chinese';
  }

  Future<void> setLanguage(String lang) async {
    state = AsyncData(lang);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, lang);
  }
}

final languageNotifierProvider =
    AsyncNotifierProvider<LanguageNotifier, String>(
  LanguageNotifier.new,
);
