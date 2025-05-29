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
