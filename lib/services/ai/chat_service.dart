import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'perplexity/perplexity_formatter.dart';
import '../../constants/app_strings.dart';
import '../../models/report_model.dart';
import '../interfaces/i_ai_service.dart';
export '../interfaces/i_ai_service.dart' show AIImageAnalysisResult;

class AIService implements IAIService {
  static final AIService instance = AIService._();
  AIService._();

  static final _riskTagRegex =
      RegExp(r'\[RISK_LEVEL:(low|medium|high)\]', caseSensitive: false);

  static RiskLevel _parseRiskLevel(String text) {
    // 第一層：從標籤解析
    final match = _riskTagRegex.firstMatch(text);
    if (match != null) {
      switch (match.group(1)!.toLowerCase()) {
        case 'low':
          return RiskLevel.safe;
        case 'medium':
          return RiskLevel.warning;
        case 'high':
          return RiskLevel.danger;
      }
    }

    // 第二層：從內文關鍵字推斷
    final lower = text.toLowerCase();
    // 高風險關鍵字
    if (lower.contains('高風險') ||
        lower.contains('high risk') ||
        lower.contains('危險') ||
        lower.contains('避免食用') ||
        lower.contains('dangerous')) {
      return RiskLevel.danger;
    }
    // 低風險關鍵字
    if (lower.contains('低風險') ||
        lower.contains('low risk') ||
        lower.contains('安全') ||
        lower.contains('safe') ||
        lower.contains('無害')) {
      return RiskLevel.safe;
    }
    // 中風險關鍵字
    if (lower.contains('中風險') ||
        lower.contains('moderate') ||
        lower.contains('medium risk') ||
        lower.contains('適量') ||
        lower.contains('注意')) {
      return RiskLevel.warning;
    }

    // 第三層：都沒有 → 不確定
    return RiskLevel.unknown;
  }

  static String _removeRiskTag(String text) {
    return text.replaceFirst(_riskTagRegex, '').trim();
  }

  static String _buildUserPrompt(String langCode, String referenceText) {
    final base =
        AppStrings.imagePrompts[langCode] ?? AppStrings.imagePrompts['en']!;
    if (referenceText.isEmpty) {
      return base;
    }
    final prefix =
        AppStrings.userNotePrefix[langCode] ?? AppStrings.userNotePrefix['en']!;
    return '$base\n\n$prefix$referenceText';
  }

  @override
  Future<AIImageAnalysisResult> processImageWithAI(
      List<File> imageFiles, String langCode,
      {String referenceText = ''}) async {
    // 將所有圖片轉為 base64
    final imageContents = <Map<String, dynamic>>[];
    for (final file in imageFiles) {
      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);
      imageContents.add({
        "type": "image_url",
        "image_url": {"url": "data:image/jpeg;base64,$base64Image"}
      });
    }

    final t = AppStrings.reportsScreenTexts[langCode] ??
        AppStrings.reportsScreenTexts['en']!;

    try {
      final response = await http
          .post(
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
                      "text": _buildUserPrompt(langCode, referenceText),
                    },
                    ...imageContents,
                  ]
                }
              ],
              "max_tokens": 1000
            }),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        // 取得原始回覆內容用於解析風險等級
        final rawContent =
            data['choices']?[0]?['message']?['content'] as String? ?? '';
        final riskLevel = _parseRiskLevel(rawContent);

        // 使用 PerplexityFormatter 處理回應，將引用標記轉換為超連結
        final formattedContent = PerplexityFormatter.formatFromResponseData(
            data,
            referenceText: referenceText);

        // 移除格式化後內容中的風險標籤
        final cleanContent = _removeRiskTag(formattedContent);

        return AIImageAnalysisResult(
          status: true,
          result: cleanContent,
          riskLevel: riskLevel,
        );
      } else {
        return AIImageAnalysisResult(
          status: false,
          result: t['analysisError']!,
          riskLevel: RiskLevel.unknown,
        );
      }
    } on TimeoutException {
      return AIImageAnalysisResult(
        status: false,
        result: t['analysisTimeout']!,
        riskLevel: RiskLevel.unknown,
      );
    } catch (e) {
      return AIImageAnalysisResult(
        status: false,
        result: t['analysisError']!,
        riskLevel: RiskLevel.unknown,
      );
    }
  }
}
