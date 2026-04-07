/// 使用量統計服務的抽象介面
abstract class IUsageService {
  /// 累加指定裝置 ID 的使用次數
  Future<void> incrementUsage(String hexId);
}
