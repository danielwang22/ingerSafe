import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../constants/app_strings.dart';
import 'app_icons.dart';

class SafetyWarningDialog extends StatelessWidget {
  final String langCode;

  const SafetyWarningDialog({super.key, this.langCode = 'zh_Hant'});

  static const _prefKey = 'safety_warning_dismissed';

  Map<String, String> get _t =>
      AppStrings.safetyWarningTexts[langCode] ??
      AppStrings.safetyWarningTexts['en']!;

  static Future<bool> shouldShow() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_prefKey) ?? false);
  }

  static void show(BuildContext context, {String langCode = 'zh_Hant'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        child: SafetyWarningDialog(langCode: langCode),
      ),
    );
  }

  static Future<void> showIfNeeded(BuildContext context,
      {String langCode = 'zh_Hant'}) async {
    final should = await shouldShow();
    if (should && context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          child: SafetyWarningDialog(langCode: langCode),
        ),
      );
    }
  }

  Future<void> _dismiss(BuildContext context,
      {bool permanently = false}) async {
    if (permanently) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefKey, true);
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? AppTheme.cardDarkColor : const Color(0xFFFAF7F5);
    final dialogBorder =
        isDark ? AppTheme.borderDarkColor : AppTheme.borderColor;
    return Container(
      constraints: const BoxConstraints(maxWidth: 382),
      decoration: BoxDecoration(
        color: dialogBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: dialogBorder),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(isDark: isDark),
                  const SizedBox(height: 20),
                  _buildWarningItem(
                    icon: AppIcons.scanEye(
                        size: 16, color: AppTheme.primaryColor),
                    color: AppTheme.primaryColor,
                    title: _t['warning2Title']!,
                    description: _t['warning2Desc']!,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  _buildWarningItem(
                    icon: AppIcons.toxic(
                        size: 16, color: const Color(0xFFD97706)),
                    color: const Color(0xFFD97706),
                    title: _t['warning1Title']!,
                    description: _t['warning1Desc']!,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),
          _buildFixedFooter(context,
              isDark: isDark, dialogBg: dialogBg, dialogBorder: dialogBorder),
        ],
      ),
    );
  }

  Widget _buildHeader({required bool isDark}) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFFD35400) : const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Center(
            child: AppIcons.shield(
                size: 28,
                color: isDark ? AppTheme.cardColor : const Color(0xFFD97706)),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _t['title']!,
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? AppTheme.cardColor : const Color(0xFF1F2E29),
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _t['subtitle']!,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isDark ? AppTheme.mutedDarkColor : const Color(0xFF677E77),
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildWarningItem({
    required Widget icon,
    required Color color,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
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
                    fontWeight: FontWeight.w600,
                    color:
                        isDark ? AppTheme.cardColor : AppTheme.foregroundColor,
                    height: 20 / 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppTheme.mutedDarkColor
                        : AppTheme.mutedForegroundColor,
                    height: 24 / 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedFooter(BuildContext context,
      {required bool isDark,
      required Color dialogBg,
      required Color dialogBorder}) {
    const outlinedBtnBg = AppTheme.backgroundColor;
    const outlinedBtnBorder = AppTheme.borderColor;
    const outlinedBtnTextColor = AppTheme.foregroundColor;
    return Container(
      decoration: BoxDecoration(
        color: dialogBg,
        border: Border(
          top: BorderSide(color: dialogBorder),
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _dismiss(context, permanently: true),
                style: OutlinedButton.styleFrom(
                  backgroundColor: outlinedBtnBg,
                  foregroundColor: outlinedBtnTextColor,
                  side: BorderSide(color: outlinedBtnBorder),
                  elevation: 0,
                  minimumSize: const Size(0, 46),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _t['dontShowAgain']!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: outlinedBtnTextColor,
                    height: 20 / 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _dismiss(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: AppTheme.cardColor,
                  elevation: 0,
                  minimumSize: const Size(0, 46),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _t['confirm']!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.cardColor,
                    height: 20 / 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
