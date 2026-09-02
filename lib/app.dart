import 'package:flutter/material.dart';
import 'core/accessibility/accessibility_settings.dart';
import 'core/constants/colors.dart';
import 'core/constants/typography.dart';
import 'features/home/home_screen.dart';

class KidsLearnApp extends StatefulWidget {
  const KidsLearnApp({super.key});

  @override
  State<KidsLearnApp> createState() => _KidsLearnAppState();
}

class _KidsLearnAppState extends State<KidsLearnApp> {
  final AccessibilitySettings _accessibilitySettings = AccessibilitySettings();

  @override
  void dispose() {
    _accessibilitySettings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AccessibilityScope(
      settings: _accessibilitySettings,
      child: MaterialApp(
        title: 'Учи со Забава',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        builder: (context, child) {
          final mediaQuery = MediaQuery.of(context);
          final systemScale = mediaQuery.textScaler.scale(1.0);
          return MediaQuery(
            data: mediaQuery.copyWith(
              textScaler: TextScaler.linear(systemScale * 1.1),
            ),
            child: child!,
          );
        },
        home: const HomeScreen(),
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: AppTypeScale.display,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: AppTypeScale.screenTitle,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: AppTypeScale.sectionTitle,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: AppTypeScale.itemTitle,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: AppTypeScale.body,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontSize: AppTypeScale.itemTitle,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
      ),
    );
  }
}
