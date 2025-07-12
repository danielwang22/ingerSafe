import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'perplexity/perplexity_formatter.dart';
import '../../constants/app_strings.dart';

class AIImageAnalysisResult {
  final bool status;
  final String result;

  AIImageAnalysisResult({
    required this.status,
    required this.result,
  });
}

class AIService {
  static Future<AIImageAnalysisResult> processImageWithAI(
      File imageFile, String langCode,
      {String referenceText = 'reference'}) async {
    final imageBytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(imageBytes);

    try {
      final response = await http.post(
        Uri.parse('https://api.perplexity.ai/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['PERPLEXITY_API_KEY']}',
        },
        body: jsonEncode({
          "model": "sonar",
          "messages": [
            {
              "role": "system",
              "content":
                  (AppStrings.prompts[langCode] ?? AppStrings.prompts['en'])
                          ?.trim() ??
                      ""
            },
            {
              "role": "user",
              "content": [
                {
                  "type": "text",
                  "text": AppStrings.imagePrompts[langCode] ??
                      AppStrings.imagePrompts['en']
                },
                {
                  "type": "image_url",
                  "image_url": {"url": "data:image/jpeg;base64,$base64Image"}
                }
              ]
            }
          ],
          "max_tokens": 1000
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        // 使用 PerplexityFormatter 處理回應，將引用標記轉換為超連結
        final formattedContent = PerplexityFormatter.formatFromResponseData(
            data,
            referenceText: referenceText);

        return AIImageAnalysisResult(status: true, result: formattedContent);
      } else {
        return AIImageAnalysisResult(status: false, result: '圖片分析 API 失敗');
      }
    } catch (e) {
      return AIImageAnalysisResult(status: false, result: '圖片分析時發生錯誤');
    }
  }
}
