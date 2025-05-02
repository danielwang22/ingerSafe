import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIImageAnalysisResult {
  final bool status;
  final String result;

  AIImageAnalysisResult({required this.status, required this.result});
}

class AIService {

  static Future<AIImageAnalysisResult> processImageWithAI(File imageFile, String targetLanguage) async {
    final imageBytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(imageBytes);

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),

        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
        },
        body: jsonEncode({
          // "model": "gpt-4.1",
          "model": "gpt-4.1-mini",
          "messages": [
            {
              // "role": "system",
              // "content": "你是一位專業的健康分析助理。請以繁體中文分析圖片中任何可辨識的成分名稱或物質，說明它們對孕婦或哺乳期女性可能造成的負面影響。即使圖片不完整，也請儘可能從中擷取資訊進行分析。\n\n請使用以下格式輸出每一項分析：\n\n物質名稱 - 簡短的專業說明，指出它可能的影響。\n\n請使用條列式呈現，簡潔明瞭、易於理解。請勿提供任何危險、不安全或未經驗證的建議。"
              "role": "system",
              "content":
              "You are a professional health analysis assistant. Please analyze any recognizable ingredients or substances found in the image, and explain their potential negative effects on pregnant or breastfeeding women. If the image contains partial or unclear text, do your best to extract useful information." +
              "List any **dangerous or high-risk substances first**, followed by substances with **minor or low-level concerns**." +
              "Please return the results as a bullet list, using the following format:" +
              "- **Substance** – Short explanation of its potential effects." +
              "Respond in ${targetLanguage}. Do not invent information that is not visible or recognizable in the image. Do not give dangerous or unverified advice."
            },
            {
              "role": "user",
              "content": [
                {
                  "type": "image_url",
                  "image_url": {
                    "url": "data:image/jpeg;base64,$base64Image"
                  }
                }
              ]
            }
          ],
          "max_tokens": 1000
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return AIImageAnalysisResult(
          status: true,
          result: data['choices'][0]['message']['content'],
        );
      } else {
        return AIImageAnalysisResult(
          status: false,
          result: '圖片分析 API 失敗',
        );
      }
    } catch (e) {
      return AIImageAnalysisResult(
        status: false,
        result: '圖片分析時發生錯誤',
      );
    }
  }
}
