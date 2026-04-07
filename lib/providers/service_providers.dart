import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/report_storage_service.dart';
import '../services/ai/chat_service.dart';
import '../services/usage_service.dart';
import '../services/text_storage_service.dart';
import '../services/tutorial_service.dart';
import '../services/history_storage_service.dart';
import '../services/interfaces/i_report_storage.dart';
import '../services/interfaces/i_ai_service.dart';
import '../services/interfaces/i_usage_service.dart';
import '../services/interfaces/i_device_id_service.dart';
import '../services/interfaces/i_tutorial_service.dart';
import '../services/interfaces/i_history_storage.dart';

final reportStorageProvider = Provider<IReportStorage>((ref) {
  return ReportStorageService.instance;
});

final aiServiceProvider = Provider<IAIService>((ref) {
  return AIService.instance;
});

final usageServiceProvider = Provider<IUsageService>((ref) {
  return ClickService.instance;
});

final deviceIdServiceProvider = Provider<IDeviceIdService>((ref) {
  return DeviceIdService.instance;
});

final tutorialServiceProvider = Provider<ITutorialService>((ref) {
  return TutorialService.instance;
});

final historyStorageProvider = Provider<IHistoryStorage>((ref) {
  return HistoryStorageService.instance;
});
