import 'dart:io';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../services/ai/chat_service.dart';
import '../services/text_storage_service.dart';
import '../services/history_storage_service.dart';
import '../services/usage_service.dart';
import '../widgets/result_dialog.dart';
import '../widgets/floating_action_buttons_widget.dart';
import '../widgets/grouped_history_list.dart';
import '../constants/app_strings.dart';
import 'package:intl/intl.dart';

Future<bool> isConnected() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}

String generateDailyDietTitle(String langCode) {
  final now = DateTime.now();

  switch (langCode) {
    case 'zh_Hant':
      return '${now.year}年${now.month}月${now.day}日的飲食';
    case 'ja':
      return '${now.year}年${now.month}月${now.day}日の食事';
    case 'ko':
      return '${now.year}년 ${now.month}월 ${now.day}일의 식사';
    default:
      return DateFormat('MMMM d, yyyy Diet').format(now);
  }
}

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isProcessing = useState(false);
    final history = useState<List<Map<String, String>>>([]);
    final hex = useState<String>(''); // Initially set to null
    final cameraKey = useMemoized(() => GlobalKey(), []);
    final galleryKey = useMemoized(() => GlobalKey(), []);
    final aboutUsKey = useMemoized(() => GlobalKey(), []);
    final isLoading = useState(true);

    // Automatically call getOrCreateHex when page loads
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final result = await getOrCreateHex();
        hex.value = result;

        final prefs = await SharedPreferences.getInstance();
        final hasShownTutorial = prefs.getBool('hasShownTutorial') ?? false;

        if (!hasShownTutorial) {
          int attempts = 0;
          const maxAttempts = 10;
          const delay = Duration(milliseconds: 300);

          while (attempts < maxAttempts) {
            final allReady = cameraKey.currentContext != null &&
                galleryKey.currentContext != null &&
                aboutUsKey.currentContext != null;

            if (context.mounted && allReady) {
              ShowCaseWidget.of(context).startShowCase([
                cameraKey,
                galleryKey,
                aboutUsKey,
              ]);
              await prefs.setBool('hasShownTutorial', true);
              break;
            }

            await Future.delayed(delay);
            attempts++;
          }
        }

        final storedHistory = await HistoryStorageService.loadHistory();
        history.value = storedHistory;
      });

      return null;
    }, []);

    final supportedLanguages = {
      'English': TextRecognitionScript.latin,
      'Traditional_Chinese': TextRecognitionScript.chinese,
      'Japanese': TextRecognitionScript.japanese,
      'Korean': TextRecognitionScript.korean,
      'Thai': TextRecognitionScript.latin,
      'Vietnamese': TextRecognitionScript.latin,
    };
    final selectedLanguage =
        useState<TextRecognitionScript>(TextRecognitionScript.chinese);
    final selectedLanguageName = useState<String>('Traditional_Chinese');

    useEffect(() {
      () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? savedLang = prefs.getString('selected_language');

        if (savedLang != null && supportedLanguages.containsKey(savedLang)) {
          selectedLanguageName.value = savedLang;
          selectedLanguage.value = supportedLanguages[savedLang]!;
        }
        isLoading.value = false; // Done loading
      }();
      return null;
    }, []);

    Future<void> updateLanguage(String newLang) async {
      if (!supportedLanguages.containsKey(newLang)) return;
      selectedLanguageName.value = newLang;
      selectedLanguage.value = supportedLanguages[newLang]!;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_language', newLang);
    }

    final languageTexts = AppStrings.homeScreenTexts;

    final localizedLanguageNames = AppStrings.languageNames;

    final langCodeByLanguageName = {
      'English': 'en',
      'Traditional_Chinese': 'zh_Hant',
      'Japanese': 'ja',
      'Korean': 'ko',
      'Thai': 'th',
      'Vietnamese': 'vi',
    };

    final langCode = langCodeByLanguageName[selectedLanguageName.value] ?? 'en';

    final t = languageTexts[selectedLanguageName.value]!;

    Future<void> processImage(XFile? image) async {
      if (image == null) return;

      if (!await isConnected()) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text("No internet connection. Please try again later.")),
          );
        }
        return;
      }

      try {
        isProcessing.value = true;
        final file = File(image.path);

        final aiResult = await AIService.processImageWithAI(file, langCode,
            referenceText: t['reference'] ?? 'reference');
        if (hex.value != '' && aiResult.status == true) {
          ClickService.incrementUsage(hex.value); // Call the function
        }

        final dailyDietTitle = generateDailyDietTitle(langCode);
        history.value = [
          {
            'text': dailyDietTitle,
            'analysis': aiResult.result,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          },
          ...history.value,
        ];
        await HistoryStorageService.saveHistory(history.value);

        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => ResultDialog(
              originalText: dailyDietTitle,
              analysis: aiResult.result,
              selectedLanguageName: langCode,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      } finally {
        isProcessing.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('IngreSafe'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<TextRecognitionScript>(
                value: selectedLanguage.value,
                icon: const Icon(Icons.language),
                alignment: Alignment.center,
                borderRadius: BorderRadius.circular(12),
                selectedItemBuilder: (BuildContext context) {
                  return supportedLanguages.entries.map((entry) {
                    final langText = localizedLanguageNames[langCode]
                            ?[entry.key] ??
                        entry.key;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 6),
                        Text(
                          langText,
                        ),
                      ],
                    );
                  }).toList();
                },
                items: supportedLanguages.entries.map((entry) {
                  final localizedNames = localizedLanguageNames[langCode]!;
                  return DropdownMenuItem<TextRecognitionScript>(
                    value: entry.value,
                    child: Text(localizedNames[entry.key] ?? entry.key),
                  );
                }).toList(),
                onChanged: (newLang) {
                  if (newLang != null) {
                    selectedLanguage.value = newLang;
                    final langName = supportedLanguages.entries
                        .firstWhere((entry) => entry.value == newLang)
                        .key;
                    updateLanguage(langName);
                    selectedLanguageName.value = langName;
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (isProcessing.value) const LinearProgressIndicator(),
          Expanded(
            child: GroupedHistoryList(
              history: history.value,
              historyNotifier: history,
              translations: t,
              langCode: langCode,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButtonsWidget(
        cameraKey: cameraKey,
        galleryKey: galleryKey,
        aboutUsKey: aboutUsKey,
        translations: t,
        isProcessing: isProcessing.value,
        processImage: processImage,
      ),
    );
  }
}
