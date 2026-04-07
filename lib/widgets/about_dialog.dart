import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../theme/app_theme.dart';
import '../constants/app_strings.dart';
import '../services/webview_service.dart';
import 'app_icons.dart';
import 'safety_warning_dialog.dart';

class AppAboutDialog extends StatefulWidget {
  final String langCode;

  const AppAboutDialog({super.key, this.langCode = 'zh_Hant'});

  static String? _cachedVersion;

  static void show(BuildContext context, {String langCode = 'zh_Hant'}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        child: AppAboutDialog(langCode: langCode),
      ),
    );
  }

  @override
  State<AppAboutDialog> createState() => _AppAboutDialogState();
}

class _AppAboutDialogState extends State<AppAboutDialog> {
  String _version = AppAboutDialog._cachedVersion ?? '';

  Map<String, String> get _t =>
      AppStrings.aboutDialogTexts[widget.langCode] ??
      AppStrings.aboutDialogTexts['en']!;

  @override
  void initState() {
    super.initState();
    if (AppAboutDialog._cachedVersion == null) {
      PackageInfo.fromPlatform().then((info) {
        AppAboutDialog._cachedVersion = info.version;
        if (mounted) setState(() => _version = info.version);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 382),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E0DC)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 15,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Scrollable area
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                      top: 32, bottom: 8, left: 20, right: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildScrollableContent(),
                    ],
                  ),
                ),
              ),
              // Fixed footer
              _buildFixedFooter(context),
            ],
          ),
          // Close button
          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: AppIcons.cross(
                    size: 30,
                    color: AppTheme.foregroundColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // App icon
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Icon(
              Icons.eco,
              size: 28,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScrollableContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        Text(
          Platform.isAndroid ? _t['descriptionAndroid']! : _t['description']!,
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF1F2E29).withValues(alpha: 0.8),
            height: 24 / 16,
          ),
        ),
        const SizedBox(height: 16),
        // Feature items
        _buildFeatureItem(
          icon: AppIcons.safe(size: 16, color: AppTheme.primaryColor),
          title: _t['feature1Title']!,
          description: _t['feature1Desc']!,
        ),
        const SizedBox(height: 12),
        _buildFeatureItem(
          icon: AppIcons.refs(size: 16, color: AppTheme.primaryColor),
          title: _t['feature2Title']!,
          description: _t['feature2Desc']!,
        ),
        const SizedBox(height: 12),
        _buildFeatureItem(
          icon: AppIcons.warning(size: 16, color: AppTheme.primaryColor),
          title: _t['feature3Title']!,
          description: _t['feature3Desc']!,
        ),
        const SizedBox(height: 16),
        // Disclaimer
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1EDEA).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _t['disclaimerAbout']!,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF677E77),
              height: 20 / 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFixedFooter(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7F5),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE5E0DC),
            width: 1,
          ),
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Safety notice link
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              SafetyWarningDialog.show(context, langCode: widget.langCode);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIcons.safe(size: 16, color: AppTheme.primaryColor),
                const SizedBox(width: 4),
                Text(
                  (AppStrings.safetyWarningTexts[widget.langCode] ??
                      AppStrings
                          .safetyWarningTexts['en']!)['viewSafetyNotice']!,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                    decoration: TextDecoration.underline,
                    decorationColor: AppTheme.primaryColor,
                    decorationThickness: 1,
                    height: 20 / 14,
                  ),
                ),
              ],
            ),
          ),
          if (Platform.isAndroid) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => WebViewService.openUrl(
                context,
                'https://buymeacoffee.com/ingresafe',
                title: 'Buy Me a Coffee',
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('☕', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(
                      'Buy Me a Coffee',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.cardColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          // Version
          Text(
            '${_t['version']} $_version · © 2025 IngreSafe',
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF677E77),
              height: 12 / 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required Widget icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(child: icon),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2E29),
                  height: 20 / 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF677E77),
                  height: 24 / 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
