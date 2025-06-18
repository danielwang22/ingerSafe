import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResultDialog extends StatelessWidget {
  final String originalText;
  final String analysis;
  final String selectedLanguageName; // Add this

  const ResultDialog({
    super.key,
    required this.originalText,
    required this.analysis,
    required this.selectedLanguageName,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, Map<String, String>> localizedLabels = {
      'en': {
        'analysisResult': 'Analysis Result',
        'noHarmfulIngredients': 'No harmful ingredients detected.',
        'potentiallyHarmfulIngredients': 'Potentially harmful ingredients:',
        'originalText': 'Original Text',
        'aiAnalysis': 'AI Analysis',
        'copyText': 'Copy Text',
        'copyOriginal': 'Original text copied',
        'copyAnalysis': 'Analysis copied',
        'disclaimer': '*This app helps you look up information about ingredients. Always consult your doctor. This app does not provide medical advice.',
      },
      'zh_Hant': {
        'analysisResult': '分析結果',
        'noHarmfulIngredients': '未檢測到有害成分。',
        'potentiallyHarmfulIngredients': '可能有害的成分：',
        'originalText': '原始文字',
        'aiAnalysis': 'AI 分析',
        'copyText': '複製',
        'copyOriginal': '已複製原始文字',
        'copyAnalysis': '已複製分析結果',
        'disclaimer': '*這款 App 協助您查詢成分相關資訊。請務必諮詢醫師，本 App 並不提供醫療建議。',
      },
      'ja': {
        'analysisResult': '分析結果',
        'noHarmfulIngredients': '有害な成分は検出されませんでした。',
        'potentiallyHarmfulIngredients': '潜在的に有害な成分：',
        'originalText': '原文',
        'aiAnalysis': 'AI分析',
        'copyText': 'コピー',
        'copyOriginal': '原文をコピーしました',
        'copyAnalysis': '分析結果をコピーしました',
        'disclaimer': '*このアプリは成分に関する情報を調べるのに役立ちます。必ず医師にご相談ください。このアプリは医療アドバイスを提供するものではありません。',
      },
      'ko': {
        'analysisResult': '분석 결과',
        'noHarmfulIngredients': '해로운 성분이 감지되지 않았습니다.',
        'potentiallyHarmfulIngredients': '잠재적으로 해로운 성분:',
        'originalText': '원본 텍스트',
        'aiAnalysis': 'AI 분석',
        'copyText': '복사',
        'copyOriginal': '원본 텍스트가 복사되었습니다',
        'copyAnalysis': '분석 결과가 복사되었습니다',
        'disclaimer': '*이 앱은 성분에 대한 정보를 확인하는 데 도움을 줍니다. 항상 의사와 상담하세요. 이 앱은 의학적 조언을 제공하지 않습니다.',
      },
    };

    final labels = switch (selectedLanguageName) {
      'zh_Hant' => localizedLabels['zh_Hant']!,
      'ja' => localizedLabels['ja']!,
      'ko' => localizedLabels['ko']!,
      _ => localizedLabels['en']!,
    };

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    labels['analysisResult']!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                labels['disclaimer']!,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    labels['aiAnalysis']!,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(5), // 依需求調整
                      minimumSize: Size(0, 0), // 依需求調整
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: analysis));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(labels['copyAnalysis']!)),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(Icons.copy),
                        SizedBox(width: 6),
                        Text(labels['copyText']!,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        analysis,
                        style: TextStyle(
                          fontFamily: 'zh-tw',
                          fontSize: 16,
                          letterSpacing: 1.5,
                          textBaseline: TextBaseline.alphabetic,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
