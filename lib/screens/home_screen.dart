import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // For TapGestureRecognizer
import 'package:showcaseview/showcaseview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart'; // For launching URLs
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../services/ai/chat_service.dart';
import '../services/text_storage_service.dart';
import '../services/history_storage_service.dart';
import '../services/usage_service.dart';
import '../services/utils/markdown_utils.dart';
import '../widgets/result_dialog.dart';
import '../constants/app_strings.dart';

Future<bool> isConnected() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
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

    final langCode = selectedLanguageName.value == 'English'
        ? 'en'
        : selectedLanguageName.value == 'Traditional_Chinese'
            ? 'zh_Hant'
            : selectedLanguageName.value == 'Japanese'
                ? 'ja'
                : 'ko'; // Default to Korean if nothing else matches

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

        final aiResult = await AIService.processImageWithAI(
            file, langCode,
            referenceText: t['reference'] ?? 'reference');
        if (hex.value != '' && aiResult.status == true) {
          ClickService.incrementUsage(hex.value); // Call the function
        }

        history.value = [
          {'text': 'Image sent to AI', 'analysis': aiResult.result},
          ...history.value,
        ];
        await HistoryStorageService.saveHistory(history.value);

        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => ResultDialog(
              originalText: 'Image content analyzed by AI',
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
                    final langText = localizedLanguageNames[
                            selectedLanguageName.value == 'English'
                                ? 'en'
                                : selectedLanguageName.value ==
                                        'Traditional_Chinese'
                                    ? 'zh_Hant'
                                    : selectedLanguageName.value == 'Japanese'
                                        ? 'ja'
                                        : 'ko']?[entry.key] ??
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
                  final localizedNames = localizedLanguageNames[
                      selectedLanguageName.value == 'English'
                          ? 'en'
                          : selectedLanguageName.value == 'Traditional_Chinese'
                              ? 'zh_Hant'
                              : selectedLanguageName.value == 'Japanese'
                                  ? 'ja'
                                  : 'ko']!;
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
            child: history.value.isEmpty
                ? Center(child: Text(t['noHistory']!))
                : ListView.builder(
                    itemCount: history.value.length,
                    itemBuilder: (context, index) {
                      final item = history.value[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                        child: Stack(
                          children: [
                            ListTile(
                              title: Text(
                                item['text']!.length > 50
                                    ? '${item['text']!.substring(0, 50)}...'
                                    : item['text']!,
                              ),
                              subtitle: Text(
                                MarkdownUtils.cleanMarkdown(item['analysis']!)
                                            .length >
                                        100
                                    ? '${MarkdownUtils.cleanMarkdown(item['analysis']!).substring(0, 100)}...'
                                    : MarkdownUtils.cleanMarkdown(
                                        item['analysis']!),
                              ),
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => ResultDialog(
                                  originalText: item['text']!,
                                  analysis: item['analysis']!,
                                  selectedLanguageName: langCode,
                                ),
                              ),
                            ),
                            // 添加三點下拉選單
                            Positioned(
                              top: 0,
                              right: 0,
                              child: PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert),
                                offset: const Offset(0, 40), // 往下偏移 40 像素
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    // 刪除該卡片及其歷史記錄
                                    final newHistory =
                                        List<Map<String, String>>.from(
                                            history.value);
                                    newHistory.removeAt(index);
                                    history.value = newHistory;

                                    // 更新儲存的檔案
                                    HistoryStorageService.saveHistory(
                                        newHistory);
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        const Icon(Icons.delete,
                                            color: Color.fromARGB(
                                                255, 253, 94, 83)),
                                        const SizedBox(width: 8),
                                        Text(t['delete']!),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Showcase(
            key: cameraKey,
            description: t['cameraTip'],
            child: FloatingActionButton(
              heroTag: 'cameraBtn', // 添加唯一的 heroTag
              onPressed: isProcessing.value
                  ? null
                  : () async {
                      try {
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.camera);
                        await processImage(image);
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(t['cameraError']!),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
              tooltip: t['takePhoto'],
              child: const Icon(Icons.camera_alt),
            ),
          ),
          const SizedBox(width: 16),
          Showcase(
            key: galleryKey,
            // title: t['galleryTip'],
            description: t['galleryTip'],
            child: FloatingActionButton(
              heroTag: 'galleryBtn', // 添加唯一的 heroTag
              onPressed: isProcessing.value
                  ? null
                  : () async {
                      try {
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        await processImage(image);
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(t['galleryError']!),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
              tooltip: t['chooseFromGallery'],
              child: const Icon(Icons.photo_library),
            ),
          ),
          const SizedBox(width: 16),
          Showcase(
            key: aboutUsKey,
            description: t['aboutUsTip'],
            child: FloatingActionButton(
              heroTag: 'aboutUsBtn',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 24,
                    insetPadding:
                        EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                    titlePadding: EdgeInsets.fromLTRB(24, 24, 8, 0),
                    contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 24),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            t['aboutUsHeading']!,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, size: 28),
                          tooltip: 'Close',
                          onPressed: () => Navigator.of(context).pop(),
                          splashRadius: 24,
                        ),
                      ],
                    ),
                    content: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t['aboutUsMessage']!,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.4,
                              ),
                            ),
                            if (Platform.isAndroid) ...[
                              const SizedBox(height: 16),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Buy me a coffee',
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          final url = Uri.parse(
                                              'https://buymeacoffee.com/ingresafe');
                                          try {
                                            if (!await launchUrl(url,
                                                mode: LaunchMode
                                                    .externalApplication)) {
                                              // print('Could not launch $url');
                                            }
                                          } catch (e) {
                                            // print('Error launching URL: $e');
                                          }
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              tooltip: 'About Us',
              child: const Icon(Icons.info_outline),
            ),
          ),
        ],
      ),
    );
  }
}
