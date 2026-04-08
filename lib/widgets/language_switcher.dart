import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ingresafe/widgets/app_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class LanguageSwitcher extends StatefulWidget {
  final String currentLanguage;
  final ValueChanged<String> onLanguageChanged;

  const LanguageSwitcher({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  static const Map<String, String> languageFlags = {
    'Traditional_Chinese': '🇹🇼',
    'English': '🇺🇸',
    'Japanese': '🇯🇵',
    'Korean': '🇰🇷',
    'Thai': '🇹🇭',
    'Vietnamese': '🇻🇳',
  };

  static const Map<String, String> languageDisplayNames = {
    'Traditional_Chinese': '繁體中文',
    'English': 'English',
    'Japanese': '日本語',
    'Korean': '한국어',
    'Thai': 'ไทย',
    'Vietnamese': 'Tiếng Việt',
  };

  static const List<String> languages = [
    'Traditional_Chinese',
    'English',
    'Japanese',
    'Korean',
    'Thai',
    'Vietnamese',
  ];

  @override
  State<LanguageSwitcher> createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isDark = false;

  void _toggleMenu() {
    if (_overlayEntry != null) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _isDark = Theme.of(context).brightness == Brightness.dark;
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Tap barrier to dismiss
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),
          ),
          // Dropdown menu
          Positioned(
            width: 161,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 4),
              targetAnchor: Alignment.bottomRight,
              followerAnchor: Alignment.topRight,
              child: _buildMenu(),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  Widget _buildMenu() {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _isDark ? AppTheme.cardDarkColor : AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isDark ? AppTheme.borderDarkColor : AppTheme.borderColor,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 6,
              offset: Offset(0, 4),
              spreadRadius: -1,
            ),
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 4,
              offset: Offset(0, 2),
              spreadRadius: -2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: LanguageSwitcher.languages.asMap().entries.map((entry) {
            final index = entry.key;
            final lang = entry.value;
            final isSelected = lang == widget.currentLanguage;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (index > 0) const SizedBox(height: 20),
                _buildMenuItem(lang, isSelected),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String lang, bool isSelected) {
    final flag = LanguageSwitcher.languageFlags[lang] ?? '';
    final name = LanguageSwitcher.languageDisplayNames[lang] ?? lang;

    return GestureDetector(
      onTap: () async {
        _removeOverlay();
        if (lang != widget.currentLanguage) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('selected_language', lang);
          widget.onLanguageChanged(lang);
        }
      },
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  height: 28 / 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected
                      ? AppTheme.primaryColor
                      : (_isDark
                          ? AppTheme.cardColor
                          : AppTheme.foregroundColor),
                  height: 28 / 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor =
        isDark ? AppTheme.mutedDarkColor : AppTheme.mutedForegroundColor;
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleMenu,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: AppIcons.globe(
              size: 30,
              color: mutedColor,
            ),
          ),
        ),
      ),
    );
  }
}
