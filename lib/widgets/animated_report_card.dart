import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import '../models/report_model.dart';
import 'report_card.dart';

class AnimatedReportCard extends StatefulWidget {
  final Report report;
  final VoidCallback onDelete;
  final VoidCallback onOpen;
  final VoidCallback onReanalyze;
  final int index;
  final String langCode;
  final GlobalKey? showcaseKey;
  final String? showcaseTitle;
  final String? showcaseDescription;

  const AnimatedReportCard({
    super.key,
    required this.report,
    required this.onDelete,
    required this.onOpen,
    required this.onReanalyze,
    required this.index,
    this.langCode = 'zh_Hant',
    this.showcaseKey,
    this.showcaseTitle,
    this.showcaseDescription,
  });

  @override
  State<AnimatedReportCard> createState() => _AnimatedReportCardState();
}

class _AnimatedReportCardState extends State<AnimatedReportCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300 + (widget.index * 50)),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    if (widget.showcaseKey != null) {
      _controller.value = 1.0;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget card = Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ReportCard(
            report: widget.report,
            onDelete: widget.onDelete,
            onOpen: widget.onOpen,
            onReanalyze: widget.onReanalyze,
            langCode: widget.langCode,
          ),
        ),
      ),
    );

    if (widget.showcaseKey != null) {
      card = Showcase(
        key: widget.showcaseKey!,
        title: widget.showcaseTitle ?? '',
        description: widget.showcaseDescription ?? '',
        targetShapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        tooltipPadding: const EdgeInsets.all(20),
        titleTextStyle:
            const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        descTextStyle: const TextStyle(fontSize: 16),
        child: card,
      );
    }

    return card;
  }
}
