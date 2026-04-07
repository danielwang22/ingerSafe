import 'dart:convert';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/report_model.dart';
import '../models/hive_adapters.dart';
import 'interfaces/i_report_storage.dart';

class ReportStorageService implements IReportStorage {
  static final ReportStorageService instance = ReportStorageService._();
  ReportStorageService._();

  static const String _boxName = 'reports';
  static const String _legacyKey = 'reports_data';
  static const String _migrationFlagKey = 'hive_migrated_v1';

  String? _docsPath;

  /// 在 main() 啟動時呼叫一次
  @override
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _docsPath = dir.path;

    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(RiskLevelAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(ReportAdapter());

    await Hive.openBox<Report>(_boxName);
    await _migrateFromSharedPrefsIfNeeded();
  }

  /// 一次性從 SharedPreferences 遷移舊資料到 Hive
  Future<void> _migrateFromSharedPrefsIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_migrationFlagKey) ?? false) return;

    final legacyJson = prefs.getString(_legacyKey);
    if (legacyJson != null && legacyJson.isNotEmpty) {
      try {
        final box = Hive.box<Report>(_boxName);
        final List<dynamic> decoded = jsonDecode(legacyJson);
        for (final j in decoded) {
          final r = Report.fromJson(j);
          await box.put(r.id, r);
        }
        await prefs.remove(_legacyKey);
      } catch (_) {
        return; // 遷移失敗保留舊資料，下次再試
      }
    }

    await prefs.setBool(_migrationFlagKey, true);
  }

  /// 將儲存的路徑（相對或絕對）解析為當前有效的絕對路徑
  @override
  String resolveImagePath(String storedPath) {
    if (storedPath.startsWith('/')) return storedPath;
    return '${_docsPath ?? ''}/$storedPath';
  }

  @override
  Future<List<Report>> loadReports() async {
    try {
      final box = Hive.box<Report>(_boxName);
      final reports = box.values.toList();
      reports.sort((a, b) => b.date.compareTo(a.date));
      return reports;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<bool> addReport(Report report) async {
    try {
      await Hive.box<Report>(_boxName).put(report.id, report);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> updateReport(Report report) async {
    try {
      final box = Hive.box<Report>(_boxName);
      if (!box.containsKey(report.id)) return false;
      await box.put(report.id, report);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> deleteReport(String id) async {
    try {
      final box = Hive.box<Report>(_boxName);
      final target = box.get(id);
      if (target != null) _deleteImages(target.imageUrls);
      await box.delete(id);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> clearAllReports() async {
    try {
      final box = Hive.box<Report>(_boxName);
      for (final r in box.values) {
        _deleteImages(r.imageUrls);
      }
      await box.clear();
      return true;
    } catch (_) {
      return false;
    }
  }

  void _deleteImages(List<String> imageUrls) {
    for (final path in imageUrls) {
      try {
        final file = File(resolveImagePath(path));
        if (file.existsSync()) file.deleteSync();
      } catch (_) {}
    }
  }
}
