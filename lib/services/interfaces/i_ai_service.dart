import 'dart:io';
import '../../models/report_model.dart';

/// AI 分析結果資料類別
class AIImageAnalysisResult {
  final bool status;
  final String result;
  final RiskLevel riskLevel;

  AIImageAnalysisResult({
    required this.status,
    required this.result,
    required this.riskLevel,
  });
}

/// AI 影像分析服務的抽象介面
abstract class IAIService {
  /// 以 AI 分析圖片，回傳分析結果
  Future<AIImageAnalysisResult> processImageWithAI(
    List<File> imageFiles,
    String langCode, {
    String referenceText,
  });
}
