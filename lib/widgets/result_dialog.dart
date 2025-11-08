import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_strings.dart';

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
    final Map<String, Map<String, String>> localizedLabels =
        AppStrings.resultDialogTexts;

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
                  Expanded(
                    child: Text(
                      originalText,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  height: 1.6,
                ),
                softWrap: true,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                      child: MarkdownBody(
                        data: analysis,
                        onTapLink: (text, href, title) {
                          // 使用預設瀏覽器開啟連結
                          if (href != null) launchUrl(Uri.parse(href));
                        },
                        styleSheet: MarkdownStyleSheet(
                          p: TextStyle(
                            fontFamily:
                                'Noto Sans CJK TC, Noto Sans CJK SC, Noto Sans CJK, system-ui, sans-serif',
                            fontSize: 16,
                            letterSpacing: 1.5,
                            height: 1.5,
                          ),
                          h1: TextStyle(
                            fontFamily:
                                'Noto Sans CJK TC, Noto Sans CJK SC, Noto Sans CJK, system-ui, sans-serif',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1.8,
                          ),
                          h2: TextStyle(
                            fontFamily:
                                'Noto Sans CJK TC, Noto Sans CJK SC, Noto Sans CJK, system-ui, sans-serif',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.7,
                          ),
                          h3: TextStyle(
                            fontFamily:
                                'Noto Sans CJK TC, Noto Sans CJK SC, Noto Sans CJK, system-ui, sans-serif',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            height: 1.6,
                          ),
                          h4: TextStyle(
                            fontFamily:
                                'Noto Sans CJK TC, Noto Sans CJK SC, Noto Sans CJK, system-ui, sans-serif',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                          ),
                          h5: TextStyle(
                            fontFamily:
                                'Noto Sans CJK TC, Noto Sans CJK SC, Noto Sans CJK, system-ui, sans-serif',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                          h6: TextStyle(
                            fontFamily:
                                'Noto Sans CJK TC, Noto Sans CJK SC, Noto Sans CJK, system-ui, sans-serif',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                          listBullet: TextStyle(
                            fontFamily:
                                'Noto Sans CJK TC, Noto Sans CJK SC, Noto Sans CJK, system-ui, sans-serif',
                            fontSize: 16,
                          ),
                          strong: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily:
                                'Noto Sans CJK TC, Noto Sans CJK SC, Noto Sans CJK, system-ui, sans-serif',
                          ),
                          em: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontFamily:
                                'Noto Sans CJK TC, Noto Sans CJK SC, Noto Sans CJK, system-ui, sans-serif',
                          ),
                          a: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? const Color(0xFF4F378B) // dark mode
                                    : const Color(0xFFEADDFF), // light mode
                            decoration: TextDecoration.none,
                          ),
                          horizontalRuleDecoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                width: 0.5, // 更細的線條，從預設的 1.0 改為 0.5
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ),
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
