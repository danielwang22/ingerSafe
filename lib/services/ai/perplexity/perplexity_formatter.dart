import 'package:flutter/material.dart';
import '../../utils/date_utils.dart';
import 'types/response.dart';

/// Perplexity API 回應格式化工具
///
/// 用於處理 Perplexity API 回傳的 markdown 格式文本，
/// 特別是處理引用標記 [1]、[2] 等與 citations 的關聯
class PerplexityFormatter {
  /// 處理 Perplexity API 回傳的 markdown 文本
  ///
  /// [content] 原始 markdown 文本
  /// [citations] 引用資料列表
  /// [searchResults] 搜尋結果列表
  ///
  /// 返回處理後的 markdown 文本，引用標記會被轉換為超連結
  static String formatMarkdownWithCitations({
    required String content,
    required List<String>? citations,
    required List<SearchResult>? searchResults,
    String referenceText = 'reference',
  }) {
    // 檢查是否有引用資料
    final hasCitations = citations != null && citations.isNotEmpty;
    final hasSearchResults = searchResults != null && searchResults.isNotEmpty;

    // 如果沒有引用資料，處理特殊情況
    if (!hasCitations) {
      return hasSearchResults
          ? _appendReferencesOnly(content, searchResults, referenceText)
          : content; // 如果沒有引用資料且沒有搜尋結果，直接返回原始內容
    }

    // 處理有引用資料的情況
    String formattedContent =
        _replaceCitationLinks(content, citations, searchResults);
    formattedContent = _appendReferences(
        formattedContent, citations, searchResults, referenceText);

    return formattedContent;
  }

  /// 僅附加參考資料（無引用標記的情況）
  static String _appendReferencesOnly(
      String content, List<SearchResult> searchResults, String referenceText) {
    String formattedContent = content;
    formattedContent += '\n\n---\n\n### $referenceText : \n\n';

    for (int i = 0; i < searchResults.length; i++) {
      formattedContent += _formatReferenceItem(i, searchResults[i]);
    }

    return formattedContent;
  }

  /// 替換引用標記為超連結
  static String _replaceCitationLinks(String content, List<String> citations,
      List<SearchResult>? searchResults) {
    // 建立引用標記的正則表達式，匹配 [1]、[2] 等格式
    final citationRegex = RegExp(r'\[(\d+)\]');

    // 替換引用標記為 markdown 格式的超連結
    return content.replaceAllMapped(citationRegex, (match) {
      final citationIndex = int.parse(match.group(1)!) - 1;

      // 檢查引用索引是否有效
      if (citationIndex >= 0 && citationIndex < citations.length) {
        // 如果有對應的搜尋結果且有 URL，使用該 URL 作為超連結
        String? url;
        if (searchResults != null && citationIndex < searchResults.length) {
          url = searchResults[citationIndex].url;
        }

        if (url != null && url.isNotEmpty) {
          // 返回帶有超連結的引用標記
          return '[${match.group(0)}]($url)';
        }
      }

      // 如果引用索引無效或沒有 URL，保持原樣
      return match.group(0)!;
    });
  }

  /// 附加參考資料列表
  static String _appendReferences(String content, List<String> citations,
      List<SearchResult>? searchResults, String referenceText) {
    String result = content;
    result += '\n\n---\n\n### $referenceText : \n\n';

    if (searchResults != null && searchResults.isNotEmpty) {
      // 有搜尋結果，使用搜尋結果中的詳細資訊
      for (int i = 0; i < citations.length; i++) {
        if (i < searchResults.length) {
          result += _formatReferenceItem(i, searchResults[i]);
        } else {
          // 如果沒有對應的搜尋結果，使用原始引用文本
          result += '${i + 1}. ${citations[i]}\n';
        }
      }
    } else {
      // 沒有搜尋結果，只使用引用文本
      for (int i = 0; i < citations.length; i++) {
        result += '${i + 1}. ${citations[i]}\n';
      }
    }

    return result;
  }

  /// 格式化單個參考資料項目
  static String _formatReferenceItem(int index, SearchResult result) {
    final title = result.title.isNotEmpty ? result.title : result.url;
    final url = result.url;

    // 根據日期可用性決定顯示方式
    String dateStr = _getFormattedDate(result);

    if (dateStr.isNotEmpty) {
      return '${index + 1}. [$title]($url) - $dateStr\n';
    } else {
      return '${index + 1}. [$title]($url)\n';
    }
  }

  /// 獲取格式化的日期字串
  static String _getFormattedDate(SearchResult result) {
    String dateStr = '';
    if (result.lastUpdated != null) {
      dateStr = AppDateUtils.formatDate(result.lastUpdated);
    } else if (result.date != null) {
      dateStr = AppDateUtils.formatDate(result.date);
    }
    return dateStr;
  }

  /// 從 Perplexity API 回應數據中提取並格式化 markdown 文本
  ///
  /// [responseData] Perplexity API 的完整回應數據
  /// [referenceText] 參考資料標題
  ///
  /// 返回處理後的 markdown 文本
  static String formatFromResponseData(
    Map<String, dynamic> responseData, {
    String referenceText = 'reference',
  }) {
    try {
      // 從回應數據中提取所需資訊
      final extractedData = _extractResponseData(responseData);

      // 格式化 markdown 文本
      return formatMarkdownWithCitations(
        content: extractedData.content,
        citations: extractedData.citations,
        searchResults: extractedData.searchResults,
        referenceText: referenceText,
      );
    } catch (e) {
      debugPrint('格式化 Perplexity 回應時發生錯誤: $e');
      // 發生錯誤時，返回原始內容或錯誤訊息
      return _getDefaultErrorContent(responseData);
    }
  }

  /// 從回應數據中提取內容、引用和搜尋結果
  static _PerplexityResponseData _extractResponseData(
      Map<String, dynamic> responseData) {
    // 提取內容
    String content = '無法解析回應內容';
    if (responseData.containsKey('choices') &&
        responseData['choices'] is List &&
        responseData['choices'].isNotEmpty &&
        responseData['choices'][0].containsKey('message') &&
        responseData['choices'][0]['message'].containsKey('content')) {
      content = responseData['choices'][0]['message']['content'] as String? ??
          content;
    }

    // 提取引用資料
    List<String>? citations;
    if (responseData.containsKey('citations') &&
        responseData['citations'] is List) {
      citations = (responseData['citations'] as List)
          .where((x) => x != null)
          .map((x) => x.toString())
          .toList();
    }

    // 提取搜尋結果
    List<SearchResult>? searchResults;
    if (responseData.containsKey('search_results') &&
        responseData['search_results'] is List) {
      searchResults = (responseData['search_results'] as List)
          .where((x) => x != null)
          .map((x) => SearchResult.fromJson(x as Map<String, dynamic>))
          .toList();
    }

    return _PerplexityResponseData(
      content: content,
      citations: citations,
      searchResults: searchResults,
    );
  }

  /// 獲取錯誤情況下的預設內容
  static String _getDefaultErrorContent(Map<String, dynamic> responseData) {
    try {
      return responseData['choices'][0]['message']['content'] ?? '處理回應時發生錯誤';
    } catch (_) {
      return '處理回應時發生錯誤';
    }
  }
}

/// 用於存儲從 Perplexity API 回應中提取的數據
class _PerplexityResponseData {
  final String content;
  final List<String>? citations;
  final List<SearchResult>? searchResults;

  _PerplexityResponseData({
    required this.content,
    this.citations,
    this.searchResults,
  });
}
