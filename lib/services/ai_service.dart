import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  static Future<String> processWithAI(String text, selectedlanguage) async {
    if (text.trim().isEmpty) {
      return '未檢測到可分析的文字內容';
    }
    if(selectedlanguage == 'Chinese'){
      selectedlanguage = "Traditional Chinese";
    }

    try {
      final response = await http.post(
        Uri.parse('https://api.deepseek.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['DEEPSEEK_API_KEY']}',
          'Accept': 'application/vnd.deepseek.v1+json'
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {
              "role": "system",
              "content": "你是一個專業的健康分析助理，請以繁體中文提供有關圖片文字中提到的物質對孕婦或哺乳期女性的負面影響的專業分析。請避免提供任何有害或不安全的內容。"
            },
            {
              "role": "user",
              "content": "回傳字請翻譯成$selectedlanguage, 這是從圖片中提取的文字，請分析並提供見解：\n\n$text"
            }
          ],
          'temperature': 0.7,
          'max_tokens': 1000
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'];
      } else {
        return 'API 請求失敗 (錯誤代碼 ${response.statusCode})';
      }
    } catch (e) {
      return '發生連線錯誤：$e';
    }
  }

  static Future<String> processImageWithAI(File imageFile) async {
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
          "model": "gpt-4-vision-preview",
          "messages": [
            {
              "role": "system",
              "content": "你是一個專業的健康分析助理，請以繁體中文分析圖片中的內容（例如成分標籤），指出是否有對孕婦或哺乳期女性有害的物質。"
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
        return data['choices'][0]['message']['content'];
      } else {
        return '圖片分析 API 失敗（錯誤代碼 ${response.statusCode}）';
      }
    } catch (e) {
      return '圖片分析時發生錯誤：$e';
    }
  }
}
