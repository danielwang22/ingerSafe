/// 歷史紀錄儲存服務的抽象介面
abstract class IHistoryStorage {
  /// 儲存歷史訊息列表
  Future<void> saveHistory(List<Map<String, String>> history);

  /// 載入歷史訊息列表
  Future<List<Map<String, String>>> loadHistory();
}
