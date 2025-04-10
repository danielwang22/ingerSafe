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

    Future<void> processAssetImage(String assetPath) async {
      try {
        isProcessing.value = true;

        final byteData = await DefaultAssetBundle.of(context).load(assetPath);
        final file = File('${(await getTemporaryDirectory()).path}/temp_asset.jpg');
        await file.writeAsBytes(byteData.buffer.asUint8List());

        final inputImage = InputImage.fromFile(file);
        final textRecognizer = TextRecognizer();
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
          // Web 平台暫時不支援 ML Kit
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Web 平台暫不支援圖片文字識別，請使用手機 App'),
              duration: Duration(seconds: 3),
            ),
          );
          return;
        } else {
          // 原生平台使用 ML Kit
          final inputImage = InputImage.fromFilePath(image.path);
          final textRecognizer = TextRecognizer();
          final result = await textRecognizer.processImage(inputImage);
          textRecognizer.close();
          recognizedText = result.text;
        }

        if (recognizedText.isEmpty) {
          throw Exception('No text detected in the image');
        }

        // Process with AI
        final aiResult = await AIService.processWithAI(recognizedText);
        
        // Add to history
        history.value = [
          {'text': recognizedText, 'analysis': aiResult},
          ...history.value,
        ];

        // Show result
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
      ),
      body: Column(
        children: [
          if (isProcessing.value)
            const LinearProgressIndicator(),
          Expanded(
            child: history.value.isEmpty
              ? const Center(
                  child: Text('No history yet. Take a photo to get started!'),
                )
              : ListView.builder(
                  itemCount: history.value.length,
                  itemBuilder: (context, index) {
                    final item = history.value[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2, // soft shadow
                      child: ListTile(
                        title: Text(item['text']!.substring(0,
                          item['text']!.length > 50 ? 50 : item['text']!.length)),
                        subtitle: Text(item['analysis']!.substring(0,
                          item['analysis']!.length > 100 ? 100 : item['analysis']!.length)),
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
                          const SnackBar(
                            content: Text('相機不支援或無法使用，請嘗試從相簿選擇照片'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
            tooltip: 'Take Photo',
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
                          const SnackBar(
                            content: Text('無法存取相簿，請稍後再試'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
            tooltip: 'Choose from Gallery',
            child: const Icon(Icons.photo_library),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: isProcessing.value
                ? null
                : () => processAssetImage('assets/images/ingredients.jpeg'),
            tooltip: 'Use Test Image',
            child: const Icon(Icons.image),
          ),
        ],
      ),
    );
  }
}
