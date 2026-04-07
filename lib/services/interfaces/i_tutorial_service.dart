import 'package:flutter/material.dart';

/// 教學導覽服務的抽象介面
abstract class ITutorialService {
  /// 是否需要顯示教學導覽
  Future<bool> shouldShowTutorial();

  /// 標記教學導覽已完成
  Future<void> markCompleted();

  /// 重置教學導覽狀態（供設定頁使用）
  Future<void> reset();

  /// 設定 Showcase 完成後的回呼
  void setShowcaseFinishCallback(VoidCallback cb);

  /// 觸發 Showcase 完成回呼
  void handleShowcaseFinish();
}
