import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:showcaseview/showcaseview.dart';
import '../models/report_model.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_report_card.dart';
import '../widgets/upload_dialog.dart';
import '../widgets/about_dialog.dart';
import '../widgets/safety_warning_dialog.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/language_switcher.dart';
import '../widgets/app_icons.dart';
import '../providers/report_providers.dart';
import '../providers/language_provider.dart';
import '../providers/service_providers.dart';
import '../services/report_storage_service.dart';
import '../constants/app_strings.dart';
import 'report_detail_screen.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  final ImagePicker _picker = ImagePicker();

  // Tutorial
  final GlobalKey _cameraShowcaseKey = GlobalKey();
  final GlobalKey _galleryShowcaseKey = GlobalKey();
  final GlobalKey _reportCardShowcaseKey = GlobalKey();
  String? _tutorialSampleReportId;

  static const _langCodeMap = {
    'English': 'en',
    'Traditional_Chinese': 'zh_Hant',
    'Japanese': 'ja',
    'Korean': 'ko',
    'Thai': 'th',
    'Vietnamese': 'vi',
  };

  /// 供非 build 情境（callback、method）使用的當前語系代碼
  String get _langCode {
    final lang =
        ref.read(languageNotifierProvider).value ?? 'Traditional_Chinese';
    return _langCodeMap[lang] ?? 'zh_Hant';
  }

  /// 供非 build 情境使用的當前語系文字映射
  Map<String, String> get _t =>
      AppStrings.reportsScreenTexts[_langCode] ??
      AppStrings.reportsScreenTexts['en']!;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 等待報告清單載入完畢後再顯示警告與教學
      await ref.read(reportsNotifierProvider.future);
      if (!mounted) return;
      await _showSafetyWarning();
      _checkAndStartTutorial();
    });
  }

  Future<void> _showSafetyWarning() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    await SafetyWarningDialog.showIfNeeded(context, langCode: _langCode);
  }

  Future<void> _checkAndStartTutorial() async {
    final should = await ref.read(tutorialServiceProvider).shouldShowTutorial();
    if (!should || !mounted) return;

    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    _startTutorialPhase1();
  }

  void _startTutorialPhase1() {
    final tTutorial =
        AppStrings.tutorialTexts[_langCode] ?? AppStrings.tutorialTexts['en']!;

    final sampleReport = Report(
      id: 'tutorial_sample_${DateTime.now().millisecondsSinceEpoch}',
      title: tTutorial['sampleTitle']!,
      summary: tTutorial['sampleSummary']!,
      fullAnalysis: tTutorial['sampleAnalysis']!,
      riskLevel: RiskLevel.warning,
      imageUrls: [],
      date: DateTime.now(),
    );

    setState(() => _tutorialSampleReportId = sampleReport.id);
    ref.read(reportsNotifierProvider.notifier).insertEphemeral(sampleReport);

    ref.read(tutorialServiceProvider).setShowcaseFinishCallback(() {
      if (!mounted) return;
      _showTutorialUploadDialog();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ShowcaseView.get()
          .startShowCase([_cameraShowcaseKey, _galleryShowcaseKey]);
    });
  }

  void _showTutorialUploadDialog() {
    showDialog(
      context: context,
      builder: (context) => UploadDialog(
        initialImages: [],
        langCode: _langCode,
        isTutorial: true,
        onSubmit: (_, __, ___) {},
      ),
    ).then((_) {
      if (!mounted) return;
      _startTutorialPhase2();
    });
  }

  void _startTutorialPhase2() {
    ref.read(tutorialServiceProvider).setShowcaseFinishCallback(() async {
      if (!mounted) return;
      if (_tutorialSampleReportId != null) {
        ref
            .read(reportsNotifierProvider.notifier)
            .removeEphemeral(_tutorialSampleReportId!);
        setState(() => _tutorialSampleReportId = null);
      }
      await ref.read(tutorialServiceProvider).markCompleted();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ShowcaseView.get().startShowCase([_reportCardShowcaseKey]);
    });
  }

  Map<String, Map<String, List<Report>>> _groupReportsByDate(
      List<Report> reports) {
    final Map<String, Map<String, List<Report>>> grouped = {};

    for (var report in reports) {
      final year = report.date.year.toString();
      final month = report.date.month.toString().padLeft(2, '0');

      if (!grouped.containsKey(year)) grouped[year] = {};
      if (!grouped[year]!.containsKey(month)) grouped[year]![month] = [];
      grouped[year]![month]!.add(report);
    }

    return grouped;
  }

  String _getMonthName(String month, Map<String, String> t) {
    final monthNames = {
      '01': t['month01'],
      '02': t['month02'],
      '03': t['month03'],
      '04': t['month04'],
      '05': t['month05'],
      '06': t['month06'],
      '07': t['month07'],
      '08': t['month08'],
      '09': t['month09'],
      '10': t['month10'],
      '11': t['month11'],
      '12': t['month12'],
    };
    return monthNames[month] ?? month;
  }

  Future<void> _handleDelete(String id) async {
    await ref.read(reportsNotifierProvider.notifier).deleteReport(id);
  }

  void _handleOpen(String id) {
    final reports = ref.read(reportsNotifierProvider).value ?? [];
    final report = reports.firstWhere((r) => r.id == id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportDetailScreen(
          report: report,
          langCode: _langCode,
        ),
      ),
    );
  }

  Future<void> _handleCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) _showUploadDialog([image]);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(_t['cameraNotAvailable'] ??
                'Camera not available on this device')),
      );
    }
  }

  Future<void> _handleGallery() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) _showUploadDialog(images);
  }

  void _handleInfo() {
    AppAboutDialog.show(context, langCode: _langCode);
  }

  Future<List<String>> _saveImagesPermanently(List<XFile> images) async {
    final dir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${dir.path}/report_images');
    if (!await imagesDir.exists()) await imagesDir.create(recursive: true);

    final saved = <String>[];
    for (final img in images) {
      final ext = img.path.contains('.') ? img.path.split('.').last : 'jpg';
      final fileName =
          '${DateTime.now().microsecondsSinceEpoch}_${saved.length}.$ext';
      final dest = File('${imagesDir.path}/$fileName');
      await File(img.path).copy(dest.path);
      saved.add('report_images/$fileName');
    }
    return saved;
  }

  void _showUploadDialog(List<XFile> images) {
    showDialog(
      context: context,
      builder: (context) => UploadDialog(
        initialImages: images,
        langCode: _langCode,
        onSubmit: (title, description, uploadedImages) async {
          if (uploadedImages.isEmpty) return;

          final messenger = ScaffoldMessenger.of(context);
          final currentLangCode = _langCode;
          final currentT = _t;

          final permanentPaths = await _saveImagesPermanently(uploadedImages);

          final tempReport = Report(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: title,
            summary: currentT['analyzing']!,
            riskLevel: RiskLevel.safe,
            imageUrls: permanentPaths,
            date: DateTime.now(),
            userNote: description.isEmpty ? null : description,
          );

          ref
              .read(reportsNotifierProvider.notifier)
              .insertEphemeral(tempReport);
          await ref
              .read(reportsNotifierProvider.notifier)
              .addReport(tempReport);
          ref.read(analyzingCountProvider.notifier).update((c) => c + 1);

          try {
            final files = uploadedImages.map((img) => File(img.path)).toList();
            final aiResult = await ref
                .read(aiServiceProvider)
                .processImageWithAI(files, currentLangCode,
                    referenceText: description);

            final updatedReport = tempReport.copyWith(
              summary: aiResult.result,
              fullAnalysis: aiResult.result,
              riskLevel: aiResult.riskLevel,
            );

            if (!mounted) return;

            await ref
                .read(reportsNotifierProvider.notifier)
                .updateReport(updatedReport);
            ref.read(analyzingCountProvider.notifier).update((c) => c - 1);

            final deviceHex = ref.read(deviceHexProvider).value ?? '';
            if (deviceHex.isNotEmpty) {
              ref.read(usageServiceProvider).incrementUsage(deviceHex);
            }
          } catch (e) {
            if (!mounted) return;
            ref.read(analyzingCountProvider.notifier).update((c) => c - 1);
            messenger.showSnackBar(
              SnackBar(
                  content:
                      Text('${currentT['analysisFailed']}${e.toString()}')),
            );
          }
        },
      ),
    );
  }

  void _showReanalyzeDialog(Report report) {
    final existingImages = report.imageUrls
        .map((p) => XFile(ReportStorageService.instance.resolveImagePath(p)))
        .toList();

    showDialog(
      context: context,
      builder: (context) => UploadDialog(
        initialImages: existingImages,
        initialTitle: report.title,
        initialNote: report.userNote,
        langCode: _langCode,
        onSubmit: (title, description, uploadedImages) async {
          if (uploadedImages.isEmpty) return;

          final messenger = ScaffoldMessenger.of(context);
          final currentLangCode = _langCode;
          final currentT = _t;

          final permanentPaths = await _saveImagesPermanently(uploadedImages);

          final updatingReport = report.copyWith(
            title: title,
            summary: currentT['analyzing']!,
            riskLevel: RiskLevel.safe,
            imageUrls: permanentPaths,
            userNote: description.isEmpty ? null : description,
          );

          await ref
              .read(reportsNotifierProvider.notifier)
              .updateReport(updatingReport);
          ref.read(analyzingCountProvider.notifier).update((c) => c + 1);

          try {
            final files = uploadedImages.map((img) => File(img.path)).toList();
            final aiResult = await ref
                .read(aiServiceProvider)
                .processImageWithAI(files, currentLangCode,
                    referenceText: description);

            final updatedReport = updatingReport.copyWith(
              summary: aiResult.result,
              fullAnalysis: aiResult.result,
              riskLevel: aiResult.riskLevel,
            );

            if (!mounted) return;

            await ref
                .read(reportsNotifierProvider.notifier)
                .updateReport(updatedReport);
            ref.read(analyzingCountProvider.notifier).update((c) => c - 1);

            final deviceHex = ref.read(deviceHexProvider).value ?? '';
            if (deviceHex.isNotEmpty) {
              ref.read(usageServiceProvider).incrementUsage(deviceHex);
            }
          } catch (e) {
            if (!mounted) return;
            ref.read(analyzingCountProvider.notifier).update((c) => c - 1);
            messenger.showSnackBar(
              SnackBar(
                  content:
                      Text('${currentT['analysisFailed']}${e.toString()}')),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Reactive state from providers
    final selectedLanguage =
        ref.watch(languageNotifierProvider).value ?? 'Traditional_Chinese';
    final langCode = _langCodeMap[selectedLanguage] ?? 'zh_Hant';
    final t = AppStrings.reportsScreenTexts[langCode] ??
        AppStrings.reportsScreenTexts['en']!;
    final reportsAsync = ref.watch(reportsNotifierProvider);
    final analyzingCount = ref.watch(analyzingCountProvider);
    final isAnalyzing = analyzingCount > 0;

    final reports = reportsAsync.value ?? [];
    final isLoading = reportsAsync.isLoading && reports.isEmpty;

    final grouped = _groupReportsByDate(reports);
    final sortedYears = grouped.keys.toList()
      ..sort((a, b) => int.parse(b).compareTo(int.parse(a)));

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor.withValues(alpha: 0.8),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: AppTheme.borderColor.withValues(alpha: 0.5),
            height: 1,
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.eco,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'IngreSafe',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          if (isAnalyzing)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 120),
                child: Text(
                  isAnalyzing ? t['aiAnalyzing']! : t['appSubtitle']!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.mutedForegroundColor,
                    height: 1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: LanguageSwitcher(
              currentLanguage: selectedLanguage,
              onLanguageChanged: (lang) {
                ref.read(languageNotifierProvider.notifier).setLanguage(lang);
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : reports.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppTheme.mutedColor,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: const Icon(
                          Icons.eco,
                          size: 32,
                          color: AppTheme.mutedForegroundColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        t['noReports']!,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 18,
                          height: 1.5,
                          color: AppTheme.mutedForegroundColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t['noReportsHint']!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                  itemCount: sortedYears.length,
                  itemBuilder: (context, yearIndex) {
                    final year = sortedYears[yearIndex];
                    final months = grouped[year]!;
                    final sortedMonths = months.keys.toList()
                      ..sort((a, b) => int.parse(b).compareTo(int.parse(a)));

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 4, right: 4, top: 0, bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$year${t['yearSuffix']}'.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.mutedForegroundColor,
                                  height: 28 / 20,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              InkWell(
                                onTap: () => _showUploadDialog([]),
                                borderRadius: BorderRadius.circular(999),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Center(
                                    child: AppIcons.plus(
                                      size: 12,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...sortedMonths.map((month) {
                          final monthReports = months[month]!
                            ..sort((a, b) => b.date.compareTo(a.date));

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 4,
                                  right: 4,
                                  top: 0,
                                  bottom: 8,
                                ),
                                child: Text(
                                  _getMonthName(month, t),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.foregroundColor
                                        .withValues(alpha: 0.7),
                                    height: 28 / 18,
                                  ),
                                ),
                              ),
                              ...monthReports.asMap().entries.map((entry) {
                                final index = entry.key;
                                final report = entry.value;
                                final isTutorialCard =
                                    report.id == _tutorialSampleReportId;
                                final tTutorial =
                                    AppStrings.tutorialTexts[langCode] ??
                                        AppStrings.tutorialTexts['en']!;
                                return AnimatedReportCard(
                                  report: report,
                                  onDelete: () => _handleDelete(report.id),
                                  onOpen: () => _handleOpen(report.id),
                                  onReanalyze: () =>
                                      _showReanalyzeDialog(report),
                                  index: index,
                                  langCode: langCode,
                                  showcaseKey: isTutorialCard
                                      ? _reportCardShowcaseKey
                                      : null,
                                  showcaseTitle: isTutorialCard
                                      ? tTutorial['cardTitle']
                                      : null,
                                  showcaseDescription: isTutorialCard
                                      ? tTutorial['cardDesc']
                                      : null,
                                );
                              }),
                            ],
                          );
                        }),
                        const SizedBox(height: 8),
                      ],
                    );
                  },
                ),
      bottomNavigationBar: BottomNav(
        onCamera: _handleCamera,
        onGallery: _handleGallery,
        onInfo: _handleInfo,
        langCode: langCode,
        cameraShowcaseKey: _cameraShowcaseKey,
        galleryShowcaseKey: _galleryShowcaseKey,
      ),
    );
  }
}
