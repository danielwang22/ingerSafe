/// Markdown 相關工具類
class MarkdownUtils {
  /// 清理 Markdown 文本，移除特殊符號和折行空白
  static String cleanMarkdown(String text) {
    // 移除 Markdown 標題符號
    text = text.replaceAll(RegExp(r'#{1,6}\s'), '');

    // 移除粗體符號
    text = text.replaceAll(RegExp(r'\*\*|__'), '');

    // 移除斜體符號
    text = text.replaceAll(RegExp(r'\*|_'), '');

    // 移除引用符號
    text = text.replaceAll(RegExp(r'^>\s', multiLine: true), '');

    // 移除列表符號
    text = text.replaceAll(
        RegExp(r'^-\s|^\*\s|^\+\s|^\d+\.\s', multiLine: true), '');

    // 移除代碼塊符號
    text = text.replaceAll(RegExp(r'```.*?```', dotAll: true), '');
    text = text.replaceAll(RegExp(r'`([^`]+)`'), r'$1');

    // 移除連結，保留文字
    text = text.replaceAll(RegExp(r'\[([^\]]+)\]\([^)]+\)'), r'$1');

    // 移除圖片標記
    text = text.replaceAll(RegExp(r'!\[([^\]]+)\]\([^)]+\)'), r'$1');

    // 移除水平線
    text =
        text.replaceAll(RegExp(r'^-{3,}|^\*{3,}|^_{3,}', multiLine: true), '');

    // 將多個空白字符替換為單個空格
    text = text.replaceAll(RegExp(r'\s+'), ' ');

    // 移除前後空白
    return text.trim();
  }
}