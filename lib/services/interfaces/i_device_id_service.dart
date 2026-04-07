/// 裝置識別碼服務的抽象介面
abstract class IDeviceIdService {
  /// 取得或建立裝置唯一識別碼（HEX 字串）
  Future<String> getOrCreateHex();
}
