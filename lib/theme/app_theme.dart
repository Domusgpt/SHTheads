import 'package:flutter/material.dart';

class AppTheme {
  static const Color darkBackground = Color(0xFF1E1E1E);
  static const Color darkSurface = Color(0xFF2C2C2C);
  static const Color accentOrange = Color(0xFFFF6D00); // Construction orange
  static const Color accentYellow = Color(0xFFFFD600); // Safety yellow
  static const Color textPrimary = Color(0xFFE0E0E0);
  static const Color textSecondary = Color(0xFFA0A0A0);

  static const Color metallicLight = Color(0xFF4A4A4A);
  static const Color metallicDark = Color(0xFF111111);

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    primaryColor: darkSurface,
    colorScheme: ColorScheme.dark(
      primary: accentOrange,
      secondary: accentYellow,
      surface: darkSurface,
      background: darkBackground,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurface,
      elevation: 4,
      shadowColor: Colors.black54,
      titleTextStyle: TextStyle(
        color: accentOrange,
        fontSize: 24,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
        fontFamily: 'Roboto', // Will stick to default bold for MVP
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 32),
      bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
      bodyMedium: TextStyle(color: textSecondary, fontSize: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentOrange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.black54, width: 2),
        ),
      ),
    ),
  );

  static BoxDecoration get neuSkeuomorphicBox => BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: metallicLight, width: 1.5),
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF383838), // Lighter top edge
        Color(0xFF222222), // Darker bottom edge
      ],
    ),
    boxShadow: const [
      // Top left light highlight
      BoxShadow(
        color: Color(0xFF4A4A4A),
        offset: Offset(-3, -3),
        blurRadius: 6,
      ),
      // Bottom right dark shadow
      BoxShadow(
        color: Color(0xFF000000),
        offset: Offset(4, 4),
        blurRadius: 8,
      ),
    ],
  );
}
