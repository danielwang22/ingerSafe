import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  static Future<String> processWithAI(String text) async {
    if (text.trim().isEmpty) {
      return '未檢測到可分析的文字內容';
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
            {'role': 'system', 'content': '你是一個擅長分析圖片文字內容的助理，請用繁體中文提供專業分析'},
            {'role': 'user', 'content': '這是從圖片中提取的文字，請分析並提供見解：\n\n$text'}
          ],
          'temperature': 0.7,
          'max_tokens': 1000
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return 'API 請求失敗 (錯誤代碼 ${response.statusCode})';
      }
    } catch (e) {
      return '發生連線錯誤：$e';
    }
  }
}
