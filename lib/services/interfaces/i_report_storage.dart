import '../../models/report_model.dart';

/// 報告儲存服務的抽象介面
abstract class IReportStorage {
  /// 初始化儲存服務（app 啟動時呼叫一次）
  Future<void> init();

  /// 載入所有報告（依日期降序排列）
  Future<List<Report>> loadReports();

  /// 新增一筆報告
  Future<bool> addReport(Report report);

  /// 更新一筆既有報告
  Future<bool> updateReport(Report report);

  /// 刪除指定 ID 的報告
  Future<bool> deleteReport(String id);

  /// 清除所有報告
  Future<bool> clearAllReports();

  /// 將儲存路徑解析為當前有效的絕對路徑
  String resolveImagePath(String storedPath);
}
