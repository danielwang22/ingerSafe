import 'package:intl/intl.dart';

/// 日期相關工具類
class AppDateUtils {
  /// 格式化日期為可讀形式
  ///
  /// [date] DateTime 日期物件
  ///
  /// 返回格式化後的日期字串，如 "2025年07月12日"
  static String formatDate(DateTime? date) {
    if (date == null) return '';

    // 使用 intl 套件格式化日期
    final formatter = DateFormat('yyyy年MM月dd日');
    return formatter.format(date);
  }
}