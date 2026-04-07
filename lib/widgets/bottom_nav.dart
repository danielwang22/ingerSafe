import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import '../theme/app_theme.dart';
import '../constants/app_strings.dart';
import 'app_icons.dart';

class BottomNav extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onInfo;
  final String langCode;
  final GlobalKey? cameraShowcaseKey;
  final GlobalKey? galleryShowcaseKey;

  const BottomNav({
    super.key,
    required this.onCamera,
    required this.onGallery,
    required this.onInfo,
    this.langCode = 'zh_Hant',
    this.cameraShowcaseKey,
    this.galleryShowcaseKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor.withValues(alpha: 0.5),
        border: Border(
          top: BorderSide(
            color: AppTheme.borderColor.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _maybeShowcase(
                showcaseKey: cameraShowcaseKey,
                title: (AppStrings.tutorialTexts[langCode] ??
                    AppStrings.tutorialTexts['en']!)['cameraTitle']!,
                description: (AppStrings.tutorialTexts[langCode] ??
                    AppStrings.tutorialTexts['en']!)['cameraDesc']!,
                child: _NavButton(
                  iconBuilder: ({size, color}) =>
                      AppIcons.camera(size: size, color: color),
                  label: (AppStrings.bottomNavTexts[langCode] ??
                      AppStrings.bottomNavTexts['en']!)['camera']!,
                  onTap: onCamera,
                ),
              ),
              const SizedBox(width: 16),
              _maybeShowcase(
                showcaseKey: galleryShowcaseKey,
                title: (AppStrings.tutorialTexts[langCode] ??
                    AppStrings.tutorialTexts['en']!)['galleryTitle']!,
                description: (AppStrings.tutorialTexts[langCode] ??
                    AppStrings.tutorialTexts['en']!)['galleryDesc']!,
                child: _NavButton(
                  iconBuilder: ({size, color}) =>
                      AppIcons.photoLibs(size: size, color: color),
                  label: (AppStrings.bottomNavTexts[langCode] ??
                      AppStrings.bottomNavTexts['en']!)['gallery']!,
                  onTap: onGallery,
                ),
              ),
              const SizedBox(width: 16),
              _NavButton(
                iconBuilder: ({size, color}) =>
                    AppIcons.info(size: size, color: color),
                label: (AppStrings.bottomNavTexts[langCode] ??
                    AppStrings.bottomNavTexts['en']!)['about']!,
                onTap: onInfo,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _maybeShowcase({
    required GlobalKey? showcaseKey,
    required String title,
    required String description,
    required Widget child,
  }) {
    if (showcaseKey == null) return child;
    return Showcase(
      key: showcaseKey,
      title: title,
      description: description,
      targetShapeBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      tooltipPadding: const EdgeInsets.all(20),
      titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      descTextStyle: const TextStyle(fontSize: 16),
      child: child,
    );
  }
}

class _NavButton extends StatefulWidget {
  final Widget Function({double? size, Color? color}) iconBuilder;
  final String label;
  final VoidCallback onTap;

  const _NavButton({
    required this.iconBuilder,
    required this.label,
    required this.onTap,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  bool get _isHighlighted => _isPressed || _isHovered;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color:
                  _isHighlighted ? AppTheme.primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              boxShadow: _isHighlighted
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.iconBuilder(
                  size: 36,
                  color: _isHighlighted
                      ? Colors.white
                      : AppTheme.mutedForegroundColor,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.label,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _isHighlighted
                          ? Colors.white
                          : AppTheme.mutedForegroundColor,
                      height: 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
