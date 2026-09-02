import 'package:flutter/material.dart';
import '../accessibility/accessibility_settings.dart';
import '../constants/typography.dart';

class PageScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Color>? gradientColors;
  final Widget? floatingActionButton;
  final bool showBack;

  const PageScaffold({
    super.key,
    required this.title,
    required this.child,
    this.gradientColors,
    this.floatingActionButton,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AccessibilityScope.of(context).palette;
    final headerColors = gradientColors ?? [palette.primary, palette.accent];
    return Scaffold(
      backgroundColor: palette.backgroundGradient.colors.first,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: headerColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: headerColors.first.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (showBack)
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: palette.onCard.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: palette.onCard,
                          size: 20,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 44),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppTypeScale.screenTitle,
                        fontWeight: FontWeight.w800,
                        color: palette.onCard,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),
            // Content
            Expanded(child: child),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
