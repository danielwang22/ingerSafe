import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../widgets/app_icons.dart';

class _LangOption {
  final String key;
  final String flag;
  final String label;
  final String desc;

  const _LangOption({
    required this.key,
    required this.flag,
    required this.label,
    required this.desc,
  });
}

const _languages = [
  _LangOption(
      key: 'Traditional_Chinese',
      flag: '🇹🇼',
      label: '繁體中文',
      desc: 'Traditional Chinese'),
  _LangOption(key: 'English', flag: '🇺🇸', label: 'English', desc: '英文'),
  _LangOption(key: 'Japanese', flag: '🇯🇵', label: '日本語', desc: 'Japanese'),
  _LangOption(key: 'Korean', flag: '🇰🇷', label: '한국어', desc: 'Korean'),
  _LangOption(key: 'Thai', flag: '🇹🇭', label: 'ไทย', desc: 'Thai'),
  _LangOption(
      key: 'Vietnamese', flag: '🇻🇳', label: 'Tiếng Việt', desc: 'Vietnamese'),
];

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? _selected;

  String _detectLanguage() {
    final locale = Platform.localeName.toLowerCase();
    if (locale.startsWith('zh')) return 'Traditional_Chinese';
    if (locale.startsWith('ja')) return 'Japanese';
    if (locale.startsWith('ko')) return 'Korean';
    if (locale.startsWith('th')) return 'Thai';
    if (locale.startsWith('vi')) return 'Vietnamese';
    return 'English';
  }

  Future<void> _confirm(String langKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', langKey);
    await prefs.setBool('language_selected', true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/reports');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 32),
                        _buildLanguageSection(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  child: _buildActions(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(16),
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
          child: const Center(
            child: Icon(Icons.eco, size: 32, color: Colors.white),
          ),
        ),
        const SizedBox(height: 10),
        // Title
        Text(
          'IngreSafe',
          style: GoogleFonts.nunito(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppTheme.foregroundColor,
            height: 32 / 24,
          ),
        ),
        const SizedBox(height: 4),
        // Subtitle
        Text(
          '孕期飲食安全助手',
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppTheme.mutedForegroundColor,
            height: 20 / 16,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            AppIcons.globe(size: 18, color: AppTheme.mutedForegroundColor),
            const SizedBox(width: 8),
            Text(
              '選擇語言 / Select Language',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.foregroundColor,
                height: 28 / 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Language list
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: List.generate(_languages.length, (i) {
              final lang = _languages[i];
              return _LanguageItem(
                lang: lang,
                isSelected: _selected == lang.key,
                isLast: i == _languages.length - 1,
                onTap: () => setState(() => _selected = lang.key),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    final hasSelection = _selected != null;

    return Column(
      children: [
        // Confirm button
        GestureDetector(
          onTap: hasSelection ? () => _confirm(_selected!) : null,
          child: AnimatedOpacity(
            opacity: hasSelection ? 1.0 : 0.4,
            duration: const Duration(milliseconds: 150),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '確認 / Confirm',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 20 / 16,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Skip
        GestureDetector(
          onTap: () => _confirm(_detectLanguage()),
          child: Text(
            '略過（自動偵測語系）',
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.mutedForegroundColor,
              height: 20 / 16,
            ),
          ),
        ),
      ],
    );
  }
}

class _LanguageItem extends StatefulWidget {
  final _LangOption lang;
  final bool isSelected;
  final bool isLast;
  final VoidCallback onTap;

  const _LanguageItem({
    required this.lang,
    required this.isSelected,
    required this.isLast,
    required this.onTap,
  });

  @override
  State<_LanguageItem> createState() => _LanguageItemState();
}

class _LanguageItemState extends State<_LanguageItem> {
  bool _isPressed = false;

  Color get _bgColor {
    if (widget.isSelected) {
      return AppTheme.primaryColor.withValues(alpha: 0.1);
    }
    if (_isPressed) {
      return AppTheme.mutedColor;
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: _bgColor,
          border: widget.isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: AppTheme.borderColor.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Radio
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primaryColor,
                  width: 1.5,
                ),
              ),
              child: widget.isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            // Flag
            Text(
              widget.lang.flag,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 12),
            // Label + desc
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.lang.label,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.foregroundColor,
                    height: 20 / 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.lang.desc,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.mutedForegroundColor,
                    height: 20 / 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
