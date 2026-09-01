import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppHelpers {
  AppHelpers._();

  /// Враќа боја врз основа на индекс (за различни картички)
  static Color getCardColor(int index) {
    final colors = [
      AppColors.animalsColor,
      AppColors.colorsShapesColor,
      AppColors.alphabetColor,
      AppColors.quizColor,
      const Color(0xFF00CEC9),
      const Color(0xFFFF7675),
      const Color(0xFF74B9FF),
      const Color(0xFF55EFC4),
    ];
    return colors[index % colors.length];
  }

  /// Враќа светла верзија на бојата
  static Color getLightColor(Color color) {
    return Color.lerp(color, Colors.white, 0.85) ?? color;
  }

  /// Форматирај резултат за квиз
  static String formatScore(int correct, int total) {
    return '$correct / $total';
  }

  /// Порака за резултат
  static String getScoreMessage(int correct, int total) {
    final percentage = (correct / total) * 100;
    if (percentage >= 80) return '🌟 Одлично! Си шампион!';
    if (percentage >= 50) return '👍 Добро! Продолжи со вежбање!';
    return '💪 Вежбај повеќе и пробај пак!';
  }

  /// Emoji за резултат
  static String getScoreEmoji(int correct, int total) {
    final percentage = (correct / total) * 100;
    if (percentage >= 80) return '🏆';
    if (percentage >= 50) return '⭐';
    return '📚';
  }

  /// Провери дали слика постои (за fallback на emoji)
  static Widget buildImageWithFallback({
    required String imagePath,
    required String fallbackEmoji,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
  }) {
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => Center(
        child: Text(
          fallbackEmoji,
          style: TextStyle(fontSize: (width ?? 80) * 0.6),
        ),
      ),
    );
  }
}
