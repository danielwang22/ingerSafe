import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/report_model.dart';
import '../services/report_storage_service.dart';
import '../theme/app_theme.dart';
import '../constants/app_strings.dart';
import 'app_icons.dart';

class ReportCard extends StatefulWidget {
  final Report report;
  final VoidCallback onDelete;
  final VoidCallback onOpen;
  final VoidCallback onReanalyze;
  final String langCode;

  const ReportCard({
    super.key,
    required this.report,
    required this.onDelete,
    required this.onOpen,
    required this.onReanalyze,
    this.langCode = 'zh_Hant',
  });

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  bool _showConfirm = false;
  bool _isDeleteActive = false;
  bool _isReanalyzeActive = false;
  bool _isNavActive = false;
  OverlayEntry? _overlayEntry;

  String get _riskLabel {
    final labels = AppStrings.riskLevelLabels[widget.langCode] ??
        AppStrings.riskLevelLabels['en']!;
    switch (widget.report.riskLevel) {
      case RiskLevel.safe:
        return labels['low']!;
      case RiskLevel.warning:
        return labels['medium']!;
      case RiskLevel.danger:
        return labels['high']!;
      case RiskLevel.unknown:
        return labels['unknown']!;
    }
  }

  RiskLevelConfig get _riskConfig {
    switch (widget.report.riskLevel) {
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

  String _formatDate(DateTime date) {
    switch (widget.langCode) {
      case 'en':
        return DateFormat('MMM d, HH:mm', 'en').format(date);
      case 'ja':
        return DateFormat('M月d日 HH:mm', 'ja').format(date);
      case 'ko':
        return DateFormat('M월 d일 HH:mm', 'ko').format(date);
      case 'th':
        return DateFormat('d MMM HH:mm', 'th').format(date);
      case 'vi':
        return DateFormat('d/M HH:mm', 'vi').format(date);
      default:
        return DateFormat('M月d日 HH:mm', 'zh_TW').format(date);
    }
  }

  Widget _buildThumbnail(String path) {
    const errorWidget = Icon(Icons.image_not_supported);
    if (path.startsWith('http')) {
      return Image.network(path,
          fit: BoxFit.cover, errorBuilder: (_, __, ___) => errorWidget);
    } else {
      final resolved = ReportStorageService.instance.resolveImagePath(path);
      return Image.file(File(resolved),
          fit: BoxFit.cover, errorBuilder: (_, __, ___) => errorWidget);
    }
  }

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

  void _handleDelete() {
    if (_showConfirm) {
      _hideConfirmOverlay();
      setState(() => _showConfirm = false);
      widget.onDelete();
    } else {
      setState(() => _showConfirm = true);
      _showConfirmOverlay();
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          _hideConfirmOverlay();
          setState(() => _showConfirm = false);
        }
      });
    }
  }

  @override
  void dispose() {
    _hideConfirmOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final riskConfig = _riskConfig;

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: widget.onOpen,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.report.imageUrls.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 64,
                        height: 64,
                        color: AppTheme.mutedColor,
                        child: _buildThumbnail(widget.report.imageUrls.first),
                      ),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.report.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  height: 28 / 18,
                                  color: AppTheme.foregroundColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget.report.fullAnalysis != null)
                              const SizedBox(width: 8),
                            if (widget.report.fullAnalysis != null)
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: riskConfig.backgroundColor,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    riskConfig.iconBuilder(
                                      size: 14,
                                      color: riskConfig.color,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _riskLabel,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: riskConfig.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.report.summary,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 20 / 16,
                            color: AppTheme.mutedForegroundColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppTheme.borderColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                ),
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(widget.report.date),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 20 / 14,
                        color: AppTheme.mutedForegroundColor,
                      ),
                    ),
                    Row(
                      children: [
                        MouseRegion(
                          onEnter: (_) =>
                              setState(() => _isDeleteActive = true),
                          onExit: (_) =>
                              setState(() => _isDeleteActive = false),
                          child: GestureDetector(
                            onTap: _handleDelete,
                            onTapDown: (_) =>
                                setState(() => _isDeleteActive = true),
                            onTapUp: (_) =>
                                setState(() => _isDeleteActive = false),
                            onTapCancel: () =>
                                setState(() => _isDeleteActive = false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: _isDeleteActive || _showConfirm
                                    ? const Color(0xFFFBECEC)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  _isDeleteActive ? 18 : 16,
                                ),
                              ),
                              child: Center(
                                child: AppIcons.trash(
                                  size: 24,
                                  color: _isDeleteActive || _showConfirm
                                      ? AppTheme.destructiveColor
                                      : AppTheme.mutedForegroundColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        MouseRegion(
                          onEnter: (_) =>
                              setState(() => _isReanalyzeActive = true),
                          onExit: (_) =>
                              setState(() => _isReanalyzeActive = false),
                          child: GestureDetector(
                            onTap: widget.onReanalyze,
                            onTapDown: (_) =>
                                setState(() => _isReanalyzeActive = true),
                            onTapUp: (_) =>
                                setState(() => _isReanalyzeActive = false),
                            onTapCancel: () =>
                                setState(() => _isReanalyzeActive = false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: _isReanalyzeActive
                                    ? AppTheme.primaryColor
                                        .withValues(alpha: 0.08)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  _isReanalyzeActive ? 18 : 16,
                                ),
                              ),
                              child: Center(
                                child: AppIcons.reanalyze(
                                  size: 22,
                                  color: _isReanalyzeActive
                                      ? AppTheme.primaryColor
                                      : AppTheme.mutedForegroundColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        MouseRegion(
                          onEnter: (_) => setState(() => _isNavActive = true),
                          onExit: (_) => setState(() => _isNavActive = false),
                          child: GestureDetector(
                            onTap: widget.onOpen,
                            onTapDown: (_) =>
                                setState(() => _isNavActive = true),
                            onTapUp: (_) =>
                                setState(() => _isNavActive = false),
                            onTapCancel: () =>
                                setState(() => _isNavActive = false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: _isNavActive
                                    ? const Color(0xFFFAF7F5)
                                        .withValues(alpha: 0.8)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  _isNavActive ? 18 : 16,
                                ),
                              ),
                              child: Center(
                                child: AppIcons.arrowRight(
                                  size: 14,
                                  color: _isNavActive
                                      ? AppTheme.primaryColor
                                      : AppTheme.mutedForegroundColor
                                          .withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
