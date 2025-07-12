// 此檔案用於處理 Perplexity API 的回應數據
// Perplexity API 的回應格式基於 OpenAI API 的格式進行封裝
//
// 使用方式：
//     final ordersResponseData = ordersResponseDataFromJson(jsonString);

// import 'package:meta/meta.dart'; // 提供 @required 等元數據註解
import 'dart:convert'; // 提供 JSON 編碼和解碼功能

/// 將 JSON 字串轉換為 OrdersResponseData 物件
/// @param str JSON 字串
/// @return OrdersResponseData 物件
OrdersResponseData ordersResponseDataFromJson(String str) =>
    OrdersResponseData.fromJson(json.decode(str));

/// 將 OrdersResponseData 物件轉換為 JSON 字串
/// @param data OrdersResponseData 物件
/// @return JSON 字串
String ordersResponseDataToJson(OrdersResponseData data) =>
    json.encode(data.toJson());

/// Perplexity API 回應的主要數據類別
/// 包含回應的所有關鍵資訊，如模型、使用量統計、搜尋結果等
class OrdersResponseData {
  final String id;

  /// 回應的唯一識別碼
  final String model;

  /// 使用的 AI 模型名稱
  final int created;

  /// 回應創建的時間戳（Unix 時間戳）
  final Usage usage;

  /// Token 使用情況統計
  final List<String> citations;

  /// 引用的來源列表
  final List<SearchResult> searchResults;

  /// 搜尋結果列表
  final String object;

  /// 物件類型標識符
  final List<Choice> choices;

  /// 回應選項列表

  /// 建構函數
  OrdersResponseData({
    required this.id,
    required this.model,
    required this.created,
    required this.usage,
    required this.citations,
    required this.searchResults,
    required this.object,
    required this.choices,
  });

  /// 從 JSON 物件創建 OrdersResponseData 實例
  /// @param json JSON 物件
  /// @return OrdersResponseData 實例
  factory OrdersResponseData.fromJson(Map<String, dynamic> json) =>
      OrdersResponseData(
        id: json["id"],
        model: json["model"],
        created: json["created"],
        usage: Usage.fromJson(json["usage"]),
        citations: List<String>.from(json["citations"].map((x) => x)),
        searchResults: List<SearchResult>.from(
            json["search_results"].map((x) => SearchResult.fromJson(x))),
        object: json["object"],
        choices:
            List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
      );

  /// 將 OrdersResponseData 轉換為 JSON 物件
  /// @return JSON 物件
  Map<String, dynamic> toJson() => {
        "id": id,
        "model": model,
        "created": created,
        "usage": usage.toJson(),
        "citations": List<dynamic>.from(citations.map((x) => x)),
        "search_results":
            List<dynamic>.from(searchResults.map((x) => x.toJson())),
        "object": object,
        "choices": List<dynamic>.from(choices.map((x) => x.toJson())),
      };
}

/// 表示 AI 回應的選項
/// 在串流回應中尤為重要，包含增量更新信息
class Choice {
  final int index;

  /// 選項的索引
  final String finishReason;

  /// 回應完成的原因（如 "stop"、"length" 等）
  final Delta message;

  /// 完整的訊息內容
  final Delta delta;

  /// 增量更新的內容（用於串流回應）

  /// 建構函數
  Choice({
    required this.index,
    required this.finishReason,
    required this.message,
    required this.delta,
  });

  /// 從 JSON 物件創建 Choice 實例
  /// @param json JSON 物件
  /// @return Choice 實例
  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        index: json["index"],
        finishReason: json["finish_reason"],
        message: Delta.fromJson(json["message"]),
        delta: Delta.fromJson(json["delta"]),
      );

  /// 將 Choice 轉換為 JSON 物件
  /// @return JSON 物件
  Map<String, dynamic> toJson() => {
        "index": index,
        "finish_reason": finishReason,
        "message": message.toJson(),
        "delta": delta.toJson(),
      };
}

/// 表示訊息或增量內容
/// 用於存儲角色和實際內容文本
class Delta {
  final String role;

  /// 角色（如 "assistant"、"user" 等）
  final String content;

  /// 實際的文本內容

  /// 建構函數
  Delta({
    required this.role,
    required this.content,
  });

  /// 從 JSON 物件創建 Delta 實例
  /// @param json JSON 物件
  /// @return Delta 實例
  factory Delta.fromJson(Map<String, dynamic> json) => Delta(
        role: json["role"],
        content: json["content"],
      );

  /// 將 Delta 轉換為 JSON 物件
  /// @return JSON 物件
  Map<String, dynamic> toJson() => {
        "role": role,
        "content": content,
      };
}

/// 表示搜尋結果項目
/// Perplexity 特有的功能，提供搜尋增強型回應的來源資訊
class SearchResult {
  final String title;

  /// 搜尋結果的標題
  final String url;

  /// 搜尋結果的網址
  final DateTime? date;

  /// 搜尋結果的發布日期
  final DateTime? lastUpdated;

  /// 搜尋結果的最後更新日期

  /// 建構函數
  SearchResult({
    required this.title,
    required this.url,
    required this.date,
    required this.lastUpdated,
  });

  /// 從 JSON 物件創建 SearchResult 實例
  /// @param json JSON 物件
  /// @return SearchResult 實例
  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
        title: json["title"],
        url: json["url"],
        date: json["date"] != null ? DateTime.parse(json["date"]) : null,
        lastUpdated: json["last_updated"] != null ? DateTime.parse(json["last_updated"]) : null,
      );

  /// 將 SearchResult 轉換為 JSON 物件
  /// @return JSON 物件
  Map<String, dynamic> toJson() {
    final result = {
      "title": title,
      "url": url,
    };
    
    // 只有在 date 非 null 時才添加到 JSON 中
    if (date != null) {
      result["date"] = "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}";
    }
    
    // 只有在 lastUpdated 非 null 時才添加到 JSON 中
    if (lastUpdated != null) {
      result["last_updated"] = "${lastUpdated!.year.toString().padLeft(4, '0')}-${lastUpdated!.month.toString().padLeft(2, '0')}-${lastUpdated!.day.toString().padLeft(2, '0')}";
    }
    
    return result;
  }
}

/// 表示 API 呼叫的使用統計
/// 包含 token 使用情況和搜尋上下文大小
class Usage {
  final int promptTokens;

  /// 提示詞使用的 token 數
  final int completionTokens;

  /// 回應使用的 token 數
  final int totalTokens;

  /// 總 token 數
  final String searchContextSize;

  /// 搜尋上下文大小

  /// 建構函數
  Usage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
    required this.searchContextSize,
  });

  /// 從 JSON 物件創建 Usage 實例
  /// @param json JSON 物件
  /// @return Usage 實例
  factory Usage.fromJson(Map<String, dynamic> json) => Usage(
        promptTokens: json["prompt_tokens"],
        completionTokens: json["completion_tokens"],
        totalTokens: json["total_tokens"],
        searchContextSize: json["search_context_size"],
      );

  /// 將 Usage 轉換為 JSON 物件
  /// @return JSON 物件
  Map<String, dynamic> toJson() => {
        "prompt_tokens": promptTokens,
        "completion_tokens": completionTokens,
        "total_tokens": totalTokens,
        "search_context_size": searchContextSize,
      };
}
