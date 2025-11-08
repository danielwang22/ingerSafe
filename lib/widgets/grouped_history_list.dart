import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/history_storage_service.dart';
import '../services/utils/markdown_utils.dart';
import 'result_dialog.dart';

class GroupedHistoryList extends StatelessWidget {
  final List<Map<String, String>> history;
  final ValueNotifier<List<Map<String, String>>> historyNotifier;
  final Map<String, String> translations;
  final String langCode;

  const GroupedHistoryList({
    super.key,
    required this.history,
    required this.historyNotifier,
    required this.translations,
    required this.langCode,
  });

  Map<String, Map<String, List<Map<String, String>>>> _groupHistoryByYear() {
    final Map<String, Map<String, List<Map<String, String>>>> grouped = {};

    for (final item in history) {
      // 如果沒有時間戳，使用當前時間
      final timestampStr =
          item['timestamp'] ?? DateTime.now().millisecondsSinceEpoch.toString();
      final timestamp =
          DateTime.fromMillisecondsSinceEpoch(int.parse(timestampStr));

      final year = timestamp.year.toString();
      final monthKey = _formatMonthKey(timestamp);

      if (!grouped.containsKey(year)) {
        grouped[year] = {};
      }
      if (!grouped[year]!.containsKey(monthKey)) {
        grouped[year]![monthKey] = [];
      }
      grouped[year]![monthKey]!.add(item);
    }

    return grouped;
  }

  String _formatMonthKey(DateTime date) {
    switch (langCode) {
      case 'zh_Hant':
        return '${date.month.toString().padLeft(2, '0')}月';
      case 'ja':
        return '${date.month}月';
      case 'ko':
        return '${date.month}월';
      default:
        return DateFormat('MMMM').format(date);
    }
  }

  String _formatDateTime(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) return '';

    try {
      final dateTime =
          DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
      return DateFormat('yyyy/MM/dd HH:mm').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  String _formatDateTimeWithPrefix(String? timestamp) {
    final dateTime = _formatDateTime(timestamp);
    return dateTime.isEmpty ? '' : '- $dateTime';
  }

  void _deleteHistoryItem(int globalIndex) {
    final newHistory = List<Map<String, String>>.from(history);
    newHistory.removeAt(globalIndex);
    historyNotifier.value = newHistory;
    HistoryStorageService.saveHistory(newHistory);
  }

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return Center(child: Text(translations['noHistory']!));
    }

    final groupedByYear = _groupHistoryByYear();
    final sortedYears = groupedByYear.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // 最新年份在前

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: sortedYears.length,
      itemBuilder: (context, yearIndex) {
        final year = sortedYears[yearIndex];
        final yearData = groupedByYear[year]!;
        final sortedMonths = yearData.keys.toList()
          ..sort((a, b) {
            // 按月份數字排序，最新月份在前
            final monthA = int.parse(a.replaceAll(RegExp(r'[^0-9]'), ''));
            final monthB = int.parse(b.replaceAll(RegExp(r'[^0-9]'), ''));
            return monthB.compareTo(monthA);
          });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 年份大標題
            Padding(
              padding: EdgeInsets.only(
                top: yearIndex == 0 ? 8 : 32,
                bottom: 16,
                left: 4,
              ),
              child: Text(
                year,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            // 該年份下的所有月份
            ...sortedMonths.map((month) {
              final monthItems = yearData[month]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 月份標題 + 時間線
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        // 月份文字 (自適應寬度)
                        Text(
                          month,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // 主時間線 (自適應寬度)
                        Expanded(
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 短線 (固定寬度)
                        Container(
                          width: 12,
                          height: 2,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        // 短線 (固定寬度)
                        Container(
                          width: 6,
                          height: 2,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 該月份的歷史記錄
                  ...monthItems.map((item) {
                    final globalIndex = history.indexOf(item);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        child: Stack(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              title: Text(
                                item['text']!.length > 50
                                    ? '${item['text']!.substring(0, 50)}...'
                                    : item['text']!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      MarkdownUtils.cleanMarkdown(
                                                      item['analysis']!)
                                                  .length >
                                              100
                                          ? '${MarkdownUtils.cleanMarkdown(item['analysis']!).substring(0, 100)}...'
                                          : MarkdownUtils.cleanMarkdown(
                                              item['analysis']!),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                        height: 1.4,
                                      ),
                                    ),
                                    if (_formatDateTimeWithPrefix(
                                            item['timestamp'])
                                        .isNotEmpty) ...[
                                      const SizedBox(height: 12),
                                      Text(
                                        _formatDateTimeWithPrefix(
                                            item['timestamp']),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => ResultDialog(
                                  originalText: item['text']!,
                                  analysis: item['analysis']!,
                                  selectedLanguageName: langCode,
                                ),
                              ),
                            ),
                            // 刪除按鈕
                            Positioned(
                              top: 8,
                              right: 8,
                              child: PopupMenuButton<String>(
                                icon: Icon(
                                  Icons.more_vert,
                                  size: 20,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant
                                      .withValues(alpha: 0.6),
                                ),
                                offset: const Offset(0, 32),
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    _deleteHistoryItem(globalIndex);
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          translations['delete']!,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              );
            }),
          ],
        );
      },
    );
  }
}
