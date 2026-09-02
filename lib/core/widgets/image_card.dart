import 'package:flutter/material.dart';
import '../constants/typography.dart';
import '../accessibility/accessibility_settings.dart';

class ImageCard extends StatelessWidget {
  final String? imagePath;
  final String fallbackEmoji;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const ImageCard({
    super.key,
    this.imagePath,
    required this.fallbackEmoji,
    required this.label,
    required this.color,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AccessibilityScope.of(context).palette;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: palette.controlBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: palette.border, width: palette.borderWidth),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath!,
                width: 80,
                height: 80,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    Text(fallbackEmoji, style: const TextStyle(fontSize: 60)),
              )
            else
              Text(fallbackEmoji, style: const TextStyle(fontSize: 60)),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: AppTypeScale.itemTitle,
                fontWeight: FontWeight.w700,
                color: palette.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
