import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // For TapGestureRecognizer
import 'package:showcaseview/showcaseview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart'; // For launching URLs
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../services/ai_service.dart';
import '../services/text_storage_service.dart';
import '../services/history_storage_service.dart';
import '../services/usage_service.dart';
import '../widgets/result_dialog.dart';

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
    // final GlobalKey _cameraKey = GlobalKey();
    // final GlobalKey _galleryKey = GlobalKey();
    // final GlobalKey _aboutUsKey = GlobalKey();
    final _cameraKey = useMemoized(() => GlobalKey(), []);
    final _galleryKey = useMemoized(() => GlobalKey(), []);
    final _aboutUsKey = useMemoized(() => GlobalKey(), []);
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
            final allReady = _cameraKey.currentContext != null &&
                _galleryKey.currentContext != null &&
                _aboutUsKey.currentContext != null;

            if (context.mounted && allReady) {
              ShowCaseWidget.of(context).startShowCase([
                _cameraKey,
                _galleryKey,
                _aboutUsKey,
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

    final languageTexts = {
      'English': {
        'currentLanguage': 'Current Language',
        'noHistory': 'No history yet. Take a photo to get started!',
        'cameraError':
            'Camera not supported or unavailable. Try selecting from gallery.',
        'galleryError': 'Unable to access gallery. Please try again later.',
        'webUnsupported':
            'Text recognition is not supported on the web. Please use the mobile app.',
        'takePhoto': 'Take Photo',
        'chooseFromGallery': 'Choose from Gallery',
        'useTestImage': 'Use Test Image',
        'aiResult': "Ai Result",
        'aboutUsHeading': 'About Us',
        'aboutUsMessage':
            'IngreSafe helps analyze product ingredients to ensure safety for pregnant or breastfeeding women. We do not collect any of your information. All information is store in your local device. If you want support us we have a Buymeacoffee. Any support will be greatly appreciate and will push us to create more useful product.',
        'cameraTip': 'Take a photo and analyze the ingredient list.',
        'galleryTip':
            'Choose an image from the gallery and then analyze the ingredient list.',
        'aboutUsTip': 'About Us',
      },
      'Traditional_Chinese': {
        'currentLanguage': '目前語言',
        'noHistory': '尚無歷史紀錄，請拍照開始使用！',
        'cameraError': '相機不支援或無法使用，請嘗試從相簿選擇照片',
        'galleryError': '無法存取相簿，請稍後再試',
        'webUnsupported': 'Web 平台暫不支援圖片文字識別，請使用手機 App',
        'takePhoto': '拍照',
        'chooseFromGallery': '從相簿選擇',
        'useTestImage': '使用測試圖片',
        'aiResult': "AI 結果",
        'aboutUsHeading': '關於我們',
        'aboutUsMessage':
            'IngreSafe 協助分析產品成分，確保對孕婦或哺乳期女性的安全。我們不會收集您的任何資訊，所有資料都儲存在您的本地設備上。如果您願意支持我們，我們有 Buy Me a Coffee 頁面。您的支持將讓我們非常感激，並激勵我們開發更多實用的產品。',
        'cameraTip': '請拍一張照片，並分析成分列表。',
        'galleryTip': '請從圖庫選擇一張圖片，然後分析成分列表。',
        'aboutUsTip': '關於我們',
      },
      'Japanese': {
        'currentLanguage': '現在の言語',
        'noHistory': '履歴がありません。写真を撮って始めましょう！',
        'cameraError': 'カメラが使用できません。ギャラリーから選んでください。',
        'galleryError': 'ギャラリーにアクセスできません。後でもう一度お試しください。',
        'webUnsupported': 'Webでは文字認識がサポートされていません。モバイルアプリを使用してください。',
        'takePhoto': '写真を撮る',
        'chooseFromGallery': 'ギャラリーから選ぶ',
        'useTestImage': 'テスト画像を使う',
        'aiResult': "AI結果",
        'aboutUsHeading': '私たちについて',
        'aboutUsMessage':
            'IngreSafeは、妊婦や授乳中の女性にとって安全な製品成分の分析をサポートします。私たちはあなたの情報を収集することはありません。すべてのデータはあなたのローカルデバイスに保存されます。もし私たちをサポートしたい場合は、Buy Me a Coffeeページがあります。どんなサポートも大変感謝しており、それが私たちにとって新しい有用な製品を作り続ける力となります。',
        'cameraTip': '写真を撮って、成分リストを分析してください。',
        'galleryTip': 'ギャラリーから画像を選んで、成分リストを分析してください。',
        'aboutUsTip': '私たちについて',
      },
      'Korean': {
        'currentLanguage': '현재 언어',
        'noHistory': '기록이 없습니다. 사진을 찍어 시작해보세요!',
        'cameraError': '카메라를 사용할 수 없습니다. 갤러리에서 선택해 주세요.',
        'galleryError': '갤러리에 접근할 수 없습니다. 나중에 다시 시도해 주세요.',
        'webUnsupported': '웹에서는 텍스트 인식이 지원되지 않습니다. 모바일 앱을 이용해 주세요.',
        'takePhoto': '사진 찍기',
        'chooseFromGallery': '갤러리에서 선택',
        'useTestImage': '테스트 이미지 사용',
        'aiResult': "AI 결과",
        'aboutUsHeading': '우리에 대해',
        'aboutUsMessage':
            'IngreSafe는 임산부와 수유부를 위한 제품 성분의 안전성을 분석하는 데 도움을 줍니다. 저희는 어떠한 정보도 수집하지 않으며, 모든 데이터는 사용자의 로컬 기기에 저장됩니다. 저희를 응원하고 싶다면 Buy Me a Coffee 페이지를 통해 지원해주실 수 있습니다. 여러분의 소중한 지원은 저희에게 큰 힘이 되며, 더 유용한 제품을 만드는 데 도움이 됩니다.',
        'cameraTip': '사진을 찍고 성분 목록을 분석해 주세요.',
        'galleryTip': '갤러리에서 이미지를 선택한 후 성분 목록을 분석해 주세요.',
        'aboutUsTip': '우리에 대해',
      },
    };

    final localizedLanguageNames = {
      'en': {
        'English': 'English',
        'Traditional_Chinese': '繁體中文',
        'Japanese': '日本語',
        'Korean': '한국어',
      },
      'zh_Hant': {
        'English': 'English',
        'Traditional_Chinese': '繁體中文',
        'Japanese': '日本語',
        'Korean': '한국어',
      },
      'ja': {
        'English': 'English',
        'Traditional_Chinese': '繁體中文',
        'Japanese': '日本語',
        'Korean': '한국어',
      },
      'ko': {
        'English': 'English',
        'Traditional_Chinese': '繁體中文',
        'Japanese': '日本語',
        'Korean': '한국어',
      },
    };

    final langCode = selectedLanguageName.value == 'English'
        ? 'en'
        : selectedLanguageName.value == 'Traditional_Chinese'
            ? 'zh_Hant'
            : selectedLanguageName.value == 'Japanese'
                ? 'ja'
                : 'ko'; // Default to Korean if nothing else matches

    final t = languageTexts[selectedLanguageName.value]!;

    Future<void> processAssetImage(String assetPath) async {
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
        if (!context.mounted) return;
        isProcessing.value = true;
        // Load image from assets and write to a temporary file
        final byteData = await DefaultAssetBundle.of(context).load(assetPath);
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/temp_asset.jpg');
        await file.writeAsBytes(byteData.buffer.asUint8List());

        // Call AI processing with image file
        final aiResult = await AIService.processImageWithAI(
            file, selectedLanguageName.value);
        if (hex.value != '' && aiResult.status == true) {
          ClickService.incrementUsage(hex.value); // Call the function
        }

        // Store and show the result
        history.value = [
          {'text': t['aiResult']!, 'analysis': aiResult.result},
          ...history.value,
        ];
        await HistoryStorageService.saveHistory(history.value);

        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => ResultDialog(
              originalText: 'Asset image analyzed by AI',
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
            file, selectedLanguageName.value);
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
                        child: ListTile(
                          title: Text(
                            item['text']!.substring(
                              0,
                              item['text']!.length > 50
                                  ? 50
                                  : item['text']!.length,
                            ),
                          ),
                          subtitle: Text(
                            item['analysis']!.substring(
                              0,
                              item['analysis']!.length > 100
                                  ? 100
                                  : item['analysis']!.length,
                            ),
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
            key: _cameraKey,
            // title: t['cameraTip'],
            description: t['cameraTip'],
            child: FloatingActionButton(
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
            key: _galleryKey,
            // title: t['galleryTip'],
            description: t['galleryTip'],
            child: FloatingActionButton(
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
          //test button start
          // FloatingActionButton(
          //   onPressed: isProcessing.value
          //       ? null
          //       : () => processAssetImage('assets/images/wipes.jpg'),
          //   tooltip: t['useTestImage'],
          //   child: const Icon(Icons.image),
          // ),
          // FloatingActionButton(
          //   child: Text("Start Tutorial"),
          //   onPressed: () {
          //     ShowCaseWidget.of(context).startShowCase([
          //       _cameraKey,
          //       _galleryKey,
          //       _aboutUsKey,
          //     ]);
          //   },
          // ),
          // FloatingActionButton(
          //   onPressed: () async {
          //     final prefs = await SharedPreferences.getInstance();
          //     // await prefs.remove('hasShownTutorial'); // This resets the flag
          //     await prefs.remove('selected_language'); // This resets the flag
          //   },
          //   child: Text("Reset Tutorial"),
          // ),
          //test button end
          // const SizedBox(width: 16),
          Showcase(
            key: _aboutUsKey,
            // title: t['aboutUsTip'],
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
