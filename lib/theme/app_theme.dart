import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF4B9B79);
  static const Color safeColor = Color(0xFF3B9B73);
  static const Color warningColor = Color(0xFFF5A623);
  static const Color dangerColor = Color(0xFFD63333);

  static const Color backgroundColor = Color(0xFFF9F7F5);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFE5E0DC);
  static const Color mutedColor = Color(0xFFF2EFEC);

  static const Color foregroundColor = Color(0xFF1F2E28);
  static const Color mutedForegroundColor = Color(0xFF667269);

  // accent: hsl(20 70% 85%)
  static const Color accentColor = Color(0xFFF5E5D9);
  // accent-foreground: hsl(20 50% 25%)
  static const Color accentForegroundColor = Color(0xFF604020);
  // destructive: hsl(0 65% 55%)
  static const Color destructiveColor = Color(0xFFD63F3F);
  // destructive-foreground: hsl(0 0% 100%)
  static const Color destructiveForegroundColor = Color(0xFFFFFFFF);

  // --- Dark mode tokens (from Figma Color System Dark) ---
  static const Color backgroundDarkColor = Color(0xFF0A0A0A);     // Scaffold background
  static const Color cardDarkColor = Color(0xFF2C2C2E);           // Header/Footer/Dialog bg
  static const Color cardBackgroundDarkColor = Color(0xFF1C1C1E); // ReportCard bg
  static const Color borderDarkColor = Color(0xFF38383A);
  static const Color mutedDarkColor = Color(0xFF8E8E93);          // muted text
  static const Color textTertiaryColor = Color(0xFF636366);       // input hint text
  static const Color warningLabelColor = Color(0xFFD35400);       // warning label
  static const Color amberColor = Color(0xFFD97706);              // safety warning icon

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: primaryColor,
      surface: cardColor,
      error: dangerColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: foregroundColor,
      onError: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: foregroundColor,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: GoogleFonts.nunito(
        color: foregroundColor,
        fontSize: 18,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
    ),
    cardTheme: CardThemeData(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: borderColor.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor,
        side: const BorderSide(color: borderColor),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      hintStyle: const TextStyle(
        color: mutedForegroundColor,
        fontSize: 14,
      ),
    ),
    textTheme: GoogleFonts.nunitoTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: foregroundColor,
          height: 1.2,
        ),
        displayMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: foregroundColor,
          height: 1.2,
        ),
        displaySmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: foregroundColor,
          height: 1.2,
        ),
        headlineMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: foregroundColor,
          height: 1.3,
        ),
        headlineSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: foregroundColor,
          height: 1.3,
        ),
        titleLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: foregroundColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: foregroundColor,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: mutedForegroundColor,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: mutedForegroundColor,
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundDarkColor,
    cardColor: cardBackgroundDarkColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: primaryColor,
      surface: cardBackgroundDarkColor,
      error: dangerColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onError: Colors.white,
    ),
    textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme),
    appBarTheme: AppBarTheme(
      backgroundColor: cardDarkColor,
      foregroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: GoogleFonts.nunito(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
    ),
    cardTheme: CardThemeData(
      color: cardBackgroundDarkColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: borderDarkColor,
          width: 1,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardBackgroundDarkColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderDarkColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderDarkColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      hintStyle: const TextStyle(
        color: textTertiaryColor,
        fontSize: 14,
      ),
    ),
  );
}

class RiskLevelConfig {
  final Color color;
  final Color backgroundColor;
  final String label;
  final Widget Function({double? size, Color? color}) iconBuilder;

  const RiskLevelConfig({
    required this.color,
    required this.backgroundColor,
    required this.label,
    required this.iconBuilder,
  });

  static RiskLevelConfig safe = RiskLevelConfig(
    color: AppTheme.safeColor,
    backgroundColor: const Color(0x1A3B9B73),
    label: '低風險',
    iconBuilder: ({double? size, Color? color}) =>
        _buildSafeIcon(size: size, color: color),
  );

  static RiskLevelConfig warning = RiskLevelConfig(
    color: AppTheme.warningColor,
    backgroundColor: const Color(0x19F4A825),
    label: '中風險',
    iconBuilder: ({double? size, Color? color}) =>
        _buildWarningIcon(size: size, color: color),
  );

  static RiskLevelConfig danger = RiskLevelConfig(
    color: AppTheme.dangerColor,
    backgroundColor: const Color(0x1AD74242),
    label: '高風險',
    iconBuilder: ({double? size, Color? color}) =>
        _buildDangerIcon(size: size, color: color),
  );

  static RiskLevelConfig unknown = RiskLevelConfig(
    color: AppTheme.mutedForegroundColor,
    backgroundColor: const Color(0x1A667269),
    label: '不確定',
    iconBuilder: ({double? size, Color? color}) =>
        Icon(Icons.help_outline, size: size, color: color ?? AppTheme.mutedForegroundColor),
  );

  // Dark mode variants — solid background, white text/icon
  static RiskLevelConfig safeDark = RiskLevelConfig(
    color: Colors.white,
    backgroundColor: AppTheme.safeColor,
    label: '低風險',
    iconBuilder: ({double? size, Color? color}) =>
        _buildSafeIcon(size: size, color: color ?? Colors.white),
  );

  static RiskLevelConfig warningDark = RiskLevelConfig(
    color: Colors.white,
    backgroundColor: AppTheme.warningLabelColor,
    label: '中風險',
    iconBuilder: ({double? size, Color? color}) =>
        _buildWarningIcon(size: size, color: color ?? Colors.white),
  );

  static RiskLevelConfig dangerDark = RiskLevelConfig(
    color: Colors.white,
    backgroundColor: AppTheme.dangerColor,
    label: '高風險',
    iconBuilder: ({double? size, Color? color}) =>
        _buildDangerIcon(size: size, color: color ?? Colors.white),
  );

  static RiskLevelConfig unknownDark = RiskLevelConfig(
    color: Colors.white,
    backgroundColor: AppTheme.mutedDarkColor,
    label: '不確定',
    iconBuilder: ({double? size, Color? color}) =>
        Icon(Icons.help_outline, size: size, color: color ?? Colors.white),
  );

  static Widget _buildSafeIcon({double? size, Color? color}) {
    return _buildSvgIcon('assets/images/icons/safe.svg',
        size: size, color: color);
  }

  static Widget _buildWarningIcon({double? size, Color? color}) {
    return _buildSvgIcon('assets/images/icons/warning.svg',
        size: size, color: color);
  }

  static Widget _buildDangerIcon({double? size, Color? color}) {
    return _buildSvgIcon('assets/images/icons/danger.svg',
        size: size, color: color);
  }

  static Widget _buildSvgIcon(String path, {double? size, Color? color}) {
    // 延遲載入 flutter_svg
    try {
      final svg = SvgPicture.asset(
        path,
        width: size,
        height: size,
        fit: BoxFit.contain,
        colorFilter:
            color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      );
      return svg;
    } catch (e) {
      // 如果 SVG 載入失敗，返回預設圖示
      return Icon(Icons.circle, size: size, color: color);
    }
  }
}
