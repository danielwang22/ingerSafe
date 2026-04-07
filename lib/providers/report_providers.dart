import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/report_model.dart';
import 'service_providers.dart';

class ReportsNotifier extends AsyncNotifier<List<Report>> {
  @override
  Future<List<Report>> build() async {
    return ref.read(reportStorageProvider).loadReports();
  }

  /// 新增報告並持久化
  Future<void> addReport(Report report) async {
    await ref.read(reportStorageProvider).addReport(report);
  }

  /// 僅在記憶體中插入（用於分析中的暫存卡片與教學範例）
  void insertEphemeral(Report report) {
    final current = List<Report>.from(state.value ?? []);
    current.insert(0, report);
    state = AsyncData(current);
  }

  /// 更新記憶體中的報告，並持久化
  Future<void> updateReport(Report report) async {
    final current = List<Report>.from(state.value ?? []);
    final index = current.indexWhere((r) => r.id == report.id);
    if (index != -1) {
      current[index] = report;
      state = AsyncData(current);
    }
    await ref.read(reportStorageProvider).updateReport(report);
  }

  /// 刪除報告（樂觀更新）
  Future<void> deleteReport(String id) async {
    state = AsyncData(
      (state.value ?? []).where((r) => r.id != id).toList(),
    );
    await ref.read(reportStorageProvider).deleteReport(id);
  }

  /// 僅從記憶體中移除（用於清除教學範例）
  void removeEphemeral(String id) {
    state = AsyncData(
      (state.value ?? []).where((r) => r.id != id).toList(),
    );
  }
}

final reportsNotifierProvider =
    AsyncNotifierProvider<ReportsNotifier, List<Report>>(
  ReportsNotifier.new,
);

/// 同時分析中的任務數量
final analyzingCountProvider = StateProvider<int>((ref) => 0);

/// 裝置唯一識別碼
final deviceHexProvider = FutureProvider<String>((ref) {
  return ref.read(deviceIdServiceProvider).getOrCreateHex();
});
