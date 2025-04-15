import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../services/ai_service.dart';
import '../widgets/result_dialog.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isProcessing = useState(false);
    final history = useState<List<Map<String, String>>>([]);

    final supportedLanguages = {
      'English': TextRecognitionScript.latin,
      'Chinese': TextRecognitionScript.chinese,
      'Japanese': TextRecognitionScript.japanese,
      'Korean': TextRecognitionScript.korean,
    };
    final selectedLanguage = useState<TextRecognitionScript>(TextRecognitionScript.chinese);
    final selectedLanguageName = useState<String>('Chinese');

    final languageTexts = {
      'English': {
        'currentLanguage': 'Current Language',
        'noHistory': 'No history yet. Take a photo to get started!',
        'cameraError': 'Camera not supported or unavailable. Try selecting from gallery.',
        'galleryError': 'Unable to access gallery. Please try again later.',
        'webUnsupported': 'Text recognition is not supported on the web. Please use the mobile app.',
        'takePhoto': 'Take Photo',
        'chooseFromGallery': 'Choose from Gallery',
        'useTestImage': 'Use Test Image',
      },
      'Chinese': {
        'currentLanguage': '目前語言',
        'noHistory': '尚無歷史紀錄，請拍照開始使用！',
        'cameraError': '相機不支援或無法使用，請嘗試從相簿選擇照片',
        'galleryError': '無法存取相簿，請稍後再試',
        'webUnsupported': 'Web 平台暫不支援圖片文字識別，請使用手機 App',
        'takePhoto': '拍照',
        'chooseFromGallery': '從相簿選擇',
        'useTestImage': '使用測試圖片',
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
      },
    };

    final t = languageTexts[selectedLanguageName.value]!;

    Future<void> processAssetImage(String assetPath) async {
      try {
        isProcessing.value = true;

        final byteData = await DefaultAssetBundle.of(context).load(assetPath);
        final file = File('${(await getTemporaryDirectory()).path}/temp_asset.jpg');
        await file.writeAsBytes(byteData.buffer.asUint8List());

        final inputImage = InputImage.fromFile(file);
        final textRecognizer = TextRecognizer(script: selectedLanguage.value);
        final result = await textRecognizer.processImage(inputImage);
        textRecognizer.close();

        final recognizedText = result.text;
        if (recognizedText.isEmpty) {
          throw Exception('No text detected in the asset image');
        }

        final aiResult = await AIService.processWithAI(recognizedText);
        history.value = [
          {'text': recognizedText, 'analysis': aiResult},
          ...history.value,
        ];

        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => ResultDialog(
              originalText: recognizedText,
              analysis: aiResult,
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

      try {
        isProcessing.value = true;

        String recognizedText;
        if (kIsWeb) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(t['webUnsupported']!),
              duration: const Duration(seconds: 3),
            ),
          );
          return;
        } else {
          final inputImage = InputImage.fromFilePath(image.path);
          final textRecognizer = TextRecognizer(script: selectedLanguage.value);
          final result = await textRecognizer.processImage(inputImage);
          textRecognizer.close();
          recognizedText = result.text;
        }

        if (recognizedText.isEmpty) {
          throw Exception('No text detected in the image');
        }

        final aiResult = await AIService.processWithAI(recognizedText);

        history.value = [
          {'text': recognizedText, 'analysis': aiResult},
          ...history.value,
        ];

        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => ResultDialog(
              originalText: recognizedText,
              analysis: aiResult,
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<TextRecognitionScript>(
                value: selectedLanguage.value,
                icon: const Icon(Icons.language, color: Colors.white),
                dropdownColor: Colors.blue,
                items: supportedLanguages.entries.map((entry) {
                  return DropdownMenuItem<TextRecognitionScript>(
                    value: entry.value,
                    child: Text(entry.key),
                  );
                }).toList(),
                onChanged: (newLang) {
                  if (newLang != null) {
                    selectedLanguage.value = newLang;
                    final langName = supportedLanguages.entries
                        .firstWhere((entry) => entry.value == newLang)
                        .key;
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
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      item['text']!.substring(
                        0,
                        item['text']!.length > 50 ? 50 : item['text']!.length,
                      ),
                    ),
                    subtitle: Text(
                      item['analysis']!.substring(
                        0,
                        item['analysis']!.length > 100 ? 100 : item['analysis']!.length,
                      ),
                    ),
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => ResultDialog(
                        originalText: item['text']!,
                        analysis: item['analysis']!,
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
          FloatingActionButton(
            onPressed: isProcessing.value
                ? null
                : () async {
              try {
                final image = await ImagePicker().pickImage(source: ImageSource.camera);
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
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: isProcessing.value
                ? null
                : () async {
              try {
                final image = await ImagePicker().pickImage(source: ImageSource.gallery);
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
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: isProcessing.value
                ? null
                : () => processAssetImage('assets/images/wipes.jpg'),
            tooltip: t['useTestImage'],
            child: const Icon(Icons.image),
          ),
        ],
      ),
    );
  }
}
