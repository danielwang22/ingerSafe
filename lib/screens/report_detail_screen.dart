import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/report_model.dart';
import '../providers/report_providers.dart';
import '../providers/service_providers.dart';
import '../services/report_storage_service.dart';
import '../services/webview_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_icons.dart';
import '../widgets/upload_dialog.dart';
import '../constants/app_strings.dart';

class ReportDetailScreen extends ConsumerStatefulWidget {
  final Report report;
  final String langCode;

  const ReportDetailScreen({
    super.key,
    required this.report,
    this.langCode = 'zh_Hant',
  });

  @override
  ConsumerState<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends ConsumerState<ReportDetailScreen> {
  int _currentPage = 0;
  late Report _report;
  bool _showConfirmDelete = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _report = widget.report;
  }

  Report get report => _report;
  Map<String, String> get _t =>
      AppStrings.reportDetailTexts[widget.langCode] ??
      AppStrings.reportDetailTexts['en']!;

  void _showConfirmOverlay() {
    final confirmText = (AppStrings.reportCardTexts[widget.langCode] ??
        AppStrings.reportCardTexts['en']!)['confirmDelete']!;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 0,
        right: 0,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.foregroundColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                confirmText,
                style: const TextStyle(
                  color: AppTheme.backgroundColor,
                  fontSize: 16,
                  height: 20 / 16,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideConfirmOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _handleDelete() async {
    if (_showConfirmDelete) {
      _hideConfirmOverlay();
      setState(() => _showConfirmDelete = false);
      await ref.read(reportsNotifierProvider.notifier).deleteReport(_report.id);
      if (mounted) Navigator.pop(context);
    } else {
      setState(() => _showConfirmDelete = true);
      _showConfirmOverlay();
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          _hideConfirmOverlay();
          setState(() => _showConfirmDelete = false);
        }
      });
    }
  }

  @override
  void dispose() {
    _hideConfirmOverlay();
    super.dispose();
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

  void _showReanalyzeDialog() {
    final existingImages = _report.imageUrls
        .map((p) => XFile(ReportStorageService.instance.resolveImagePath(p)))
        .toList();

    showDialog(
      context: context,
      builder: (ctx) => UploadDialog(
        initialImages: existingImages,
        initialTitle: _report.title,
        initialNote: _report.userNote,
        langCode: widget.langCode,
        onSubmit: (title, description, uploadedImages) async {
          if (uploadedImages.isEmpty) return;

          final messenger = ScaffoldMessenger.of(context);
          final t = _t;

          final permanentPaths = await _saveImagesPermanently(uploadedImages);

          final updatingReport = _report.copyWith(
            title: title,
            summary: t['analyzing'] ?? '分析中...',
            fullAnalysis: null,
            riskLevel: RiskLevel.safe,
            imageUrls: permanentPaths,
            userNote: description.isEmpty ? null : description,
          );

          await ref
              .read(reportsNotifierProvider.notifier)
              .updateReport(updatingReport);
          setState(() => _report = updatingReport);
          ref.read(analyzingCountProvider.notifier).update((c) => c + 1);

          try {
            final files = uploadedImages.map((img) => File(img.path)).toList();
            final aiResult = await ref
                .read(aiServiceProvider)
                .processImageWithAI(files, widget.langCode,
                    referenceText: description);

            final updatedReport = updatingReport.copyWith(
              summary: aiResult.result,
              fullAnalysis: aiResult.result,
              riskLevel: aiResult.riskLevel,
            );

            if (!mounted) return;
            setState(() => _report = updatedReport);
            await ref
                .read(reportsNotifierProvider.notifier)
                .updateReport(updatedReport);
            ref.read(analyzingCountProvider.notifier).update((c) => c - 1);
          } catch (e) {
            if (!mounted) return;
            ref.read(analyzingCountProvider.notifier).update((c) => c - 1);
            messenger.showSnackBar(
              SnackBar(content: Text('${t['analysisFailed'] ?? ''}$e')),
            );
          }
        },
      ),
    );
  }

  RiskLevelConfig get _riskConfig {
    switch (report.riskLevel) {
      case RiskLevel.safe:
        return RiskLevelConfig.safe;
      case RiskLevel.warning:
        return RiskLevelConfig.warning;
      case RiskLevel.danger:
        return RiskLevelConfig.danger;
      case RiskLevel.unknown:
        return RiskLevelConfig.unknown;
    }
  }

  String get _riskLabel {
    switch (report.riskLevel) {
      case RiskLevel.safe:
        return _t['riskLow']!;
      case RiskLevel.warning:
        return _t['riskMedium']!;
      case RiskLevel.danger:
        return _t['riskHigh']!;
      case RiskLevel.unknown:
        return _t['riskUnknown']!;
    }
  }

  /// 將 fullAnalysis 拆成「分析內文」和「參考文獻列表」
  /// PerplexityFormatter 用 `---` 分隔兩者
  ({String analysis, List<_Reference> references}) _splitContent() {
    final content = report.fullAnalysis ?? report.summary;
    final separatorIndex = content.indexOf('\n---\n');

    if (separatorIndex == -1) {
      return (analysis: content, references: []);
    }

    final analysis = content.substring(0, separatorIndex).trim();
    final refsSection = content.substring(separatorIndex + 5).trim();

    // 解析參考文獻：格式為 "1. [title](url) - date"
    final refRegex = RegExp(r'\d+\.\s+\[(.+?)\]\((.+?)\)(?:\s*-\s*(.+))?');
    final references = <_Reference>[];
    for (final match in refRegex.allMatches(refsSection)) {
      references.add(
        _Reference(
          title: match.group(1) ?? '',
          url: match.group(2) ?? '',
          date: match.group(3),
        ),
      );
    }

    return (analysis: analysis, references: references);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final riskConfig = _riskConfig;
    final content = _splitContent();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
              ),
              child: Center(
                child: AppIcons.arrow2Left(
                  size: 20,
                  color: AppTheme.foregroundColor,
                ),
              ),
            ),
          ),
        ),
        titleSpacing: 8,
        title: Text(
          _t['safetyReport']!,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.foregroundColor,
            height: 28 / 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showReanalyzeDialog,
            icon: AppIcons.reanalyze(
              size: 25,
              color: AppTheme.mutedForegroundColor.withValues(alpha: 0.7),
            ),
            tooltip: _t['reanalyze'] ?? 'Re-analyze',
          ),
          IconButton(
            onPressed: _handleDelete,
            icon: AppIcons.trash(
              size: 25,
              color: _showConfirmDelete
                  ? AppTheme.destructiveColor
                  : AppTheme.mutedForegroundColor.withValues(alpha: 0.7),
            ),
            tooltip: _t['delete'] ?? 'Delete',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (report.imageUrls.isNotEmpty) _buildImageCarousel(),
            if (report.fullAnalysis != null) const SizedBox(height: 16),
            // Risk level banner
            if (report.fullAnalysis != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: riskConfig.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: riskConfig.color.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    riskConfig.iconBuilder(size: 20, color: riskConfig.color),
                    const SizedBox(width: 8),
                    Text(
                      _riskLabel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: riskConfig.color,
                        height: 20 / 16,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            // Title + Analysis Card
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      report.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.foregroundColor,
                        height: 28 / 20,
                      ),
                    ),
                    const SizedBox(height: 16),
                    MarkdownBody(
                      data: content.analysis,
                      selectable: true,
                      styleSheet: _markdownStyle(theme),
                      onTapLink: _onTapLink,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // References Card
            if (content.references.isNotEmpty)
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppIcons.refs(size: 20, color: AppTheme.primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            _t['references']!,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.foregroundColor,
                              height: 28 / 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...content.references.map(
                        (ref) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildReference(ref),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                _t['disclaimer']!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.mutedForegroundColor,
                  fontSize: 14,
                  height: 20 / 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  MarkdownStyleSheet _markdownStyle(ThemeData theme) {
    return MarkdownStyleSheet(
      p: theme.textTheme.bodyLarge?.copyWith(
        color: AppTheme.mutedForegroundColor,
        fontSize: 18,
        height: 1.8,
      ),
      strong: theme.textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppTheme.foregroundColor,
        fontSize: 18,
        height: 1.8,
      ),
      h1: theme.textTheme.headlineSmall?.copyWith(
        color: AppTheme.foregroundColor,
        fontSize: 20,
        height: 1.8,
      ),
      h2: theme.textTheme.headlineSmall?.copyWith(
        color: AppTheme.foregroundColor,
        fontSize: 20,
        height: 1.8,
      ),
      h3: theme.textTheme.headlineSmall?.copyWith(
        color: AppTheme.foregroundColor,
        fontSize: 20,
        height: 1.8,
      ),
      h4: theme.textTheme.headlineSmall?.copyWith(
        color: AppTheme.foregroundColor,
        fontSize: 20,
        height: 1.8,
      ),
      h5: theme.textTheme.headlineSmall?.copyWith(
        color: AppTheme.foregroundColor,
        fontSize: 20,
        height: 1.8,
      ),
      h6: theme.textTheme.headlineSmall?.copyWith(
        color: AppTheme.foregroundColor,
        fontSize: 20,
        height: 1.8,
      ),
      listBullet: theme.textTheme.bodyLarge?.copyWith(
        color: AppTheme.mutedForegroundColor,
        fontSize: 18,
        height: 1.8,
      ),
      a: const TextStyle(
        color: AppTheme.primaryColor,
        fontSize: 18,
        height: 1.8,
        decoration: TextDecoration.underline,
      ),
    );
  }

  void _onTapLink(String text, String? href, String title) {
    if (href != null) {
      WebViewService.openUrl(context, href);
    }
  }

  Widget _buildReference(_Reference ref) {
    return GestureDetector(
      onTap: ref.url.isNotEmpty
          ? () => WebViewService.openUrl(context, ref.url)
          : null,
      child: Container(
        padding: const EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: AppTheme.primaryColor.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
        ),
        child: ref.date != null
            ? Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: ref.title,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppTheme.primaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: AppTheme.primaryColor,
                        height: 1.8,
                      ),
                    ),
                    TextSpan(
                      text: ' — ${ref.date}',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppTheme.mutedForegroundColor,
                        height: 1.8,
                      ),
                    ),
                  ],
                ),
              )
            : Text(
                ref.title,
                style: TextStyle(
                  fontSize: 18,
                  color: AppTheme.primaryColor,
                  decoration: TextDecoration.underline,
                  decorationColor: AppTheme.primaryColor,
                  height: 1.8,
                ),
              ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    final images = report.imageUrls;

    Widget imageArea;
    if (images.length == 1) {
      imageArea = AspectRatio(
        aspectRatio: 16 / 9,
        child: GestureDetector(
          onTap: () => _openLightbox(context, 0),
          child: _buildSingleImage(images.first),
        ),
      );
    } else {
      imageArea = AspectRatio(
        aspectRatio: 16 / 9,
        child: PageView.builder(
          itemCount: images.length,
          onPageChanged: (index) => setState(() => _currentPage = index),
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => _openLightbox(context, index),
            child: _buildSingleImage(images[index]),
          ),
        ),
      );
    }

    final framed = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.borderColor, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            imageArea,
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.zoom_in, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
      ),
    );

    if (images.length == 1) return framed;

    return Column(
      children: [
        framed,
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(images.length, (index) {
            final isActive = index == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive
                    ? AppTheme.primaryColor
                    : AppTheme.mutedForegroundColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  void _openLightbox(BuildContext context, int initialIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, __, ___) => _LightboxPage(
          imagePaths: report.imageUrls,
          initialIndex: initialIndex,
        ),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  Widget _buildSingleImage(String path) {
    final errorWidget = Container(
      color: AppTheme.mutedColor,
      child: const Icon(Icons.image_not_supported),
    );

    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => errorWidget,
      );
    } else {
      final resolved = ReportStorageService.instance.resolveImagePath(path);
      return Image.file(
        File(resolved),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => errorWidget,
      );
    }
  }
}

class _LightboxPage extends StatefulWidget {
  final List<String> imagePaths;
  final int initialIndex;

  const _LightboxPage({required this.imagePaths, required this.initialIndex});

  @override
  State<_LightboxPage> createState() => _LightboxPageState();
}

class _LightboxPageState extends State<_LightboxPage> {
  late int _current;
  late PageController _pageCtrl;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _pageCtrl = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  Widget _buildImage(String path) {
    if (path.startsWith('http')) {
      return Image.network(path, fit: BoxFit.contain);
    }
    final resolved = ReportStorageService.instance.resolveImagePath(path);
    return Image.file(File(resolved), fit: BoxFit.contain);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageCtrl,
            itemCount: widget.imagePaths.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) => InteractiveViewer(
              minScale: 0.5,
              maxScale: 5.0,
              child: Center(child: _buildImage(widget.imagePaths[i])),
            ),
          ),
          // 頁數（多圖時顯示）
          if (widget.imagePaths.length > 1)
            Positioned(
              top: topPad + 16,
              left: 16,
              child: Text(
                '${_current + 1} / ${widget.imagePaths.length}',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          // 關閉按鈕
          Positioned(
            top: topPad + 4,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 26),
              style: IconButton.styleFrom(backgroundColor: Colors.black45),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          // 底部 dot indicator（多圖時顯示）
          if (widget.imagePaths.length > 1)
            Positioned(
              bottom: bottomPad + 24,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.imagePaths.length, (i) {
                  final isActive = i == _current;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isActive ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

class _Reference {
  final String title;
  final String url;
  final String? date;

  _Reference({required this.title, required this.url, this.date});
}
