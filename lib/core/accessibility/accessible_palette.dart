import 'package:flutter/material.dart';
import 'accessibility_settings.dart';

@immutable
class AccessiblePalette {
  const AccessiblePalette({
    required this.primary,
    required this.accent,
    required this.backgroundGradient,
    required this.cardGradients,
    required this.quizGradient,
    required this.textPrimary,
    required this.textSecondary,
    required this.onCard,
    required this.onCardSecondary,
    required this.border,
    required this.selected,
    required this.selectedBackground,
    required this.controlBackground,
    required this.correct,
    required this.correctBackground,
    required this.incorrect,
    required this.incorrectBackground,
    this.borderWidth = 1.5,
  });

  final Color primary;
  final Color accent;

  final LinearGradient backgroundGradient;
  final List<LinearGradient> cardGradients;
  final LinearGradient quizGradient;

  final Color textPrimary;
  final Color textSecondary;

  final Color onCard;
  final Color onCardSecondary;

  final Color border;
  final Color selected;
  final Color selectedBackground;
  final Color controlBackground;

  final Color correct;
  final Color correctBackground;
  final Color incorrect;
  final Color incorrectBackground;

  final double borderWidth;

  LinearGradient get animalsGradient => cardGradients[0];
  LinearGradient get colorsShapesGradient => cardGradients[1];
  LinearGradient get alphabetGradient => cardGradients[2];
  LinearGradient get plantsGradient => cardGradients[3];
  LinearGradient get allCategoriesGradient => cardGradients[4];

  Color itemAccent(int index) {
    final colors = cardGradients.expand((g) => g.colors).toList();
    return colors[index % colors.length];
  }

  Color tintedSurface(Color accent, [double amount = .85]) =>
      Color.lerp(accent, controlBackground, amount)!;
}

class AccessiblePalettes {
  AccessiblePalettes._();

  static LinearGradient _gradient(Color first, Color second) =>
      LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [first, second],
      );

  static AccessiblePalette forMode(ColorVisionMode mode) => switch (mode) {
    ColorVisionMode.standard => standard,
    ColorVisionMode.highContrast => highContrast,
    ColorVisionMode.protanopia => protanopia,
    ColorVisionMode.deuteranopia => deuteranopia,
    ColorVisionMode.tritanopia => tritanopia,
  };

  // ================= STANDARD =================

  static final standard = AccessiblePalette(
    primary: const Color(0xFFFF6B35),
    accent: const Color(0xFF4ECDC4),

    backgroundGradient: _gradient(
      const Color(0xFFFFF9F0),
      const Color(0xFFFFEDD8),
    ),

    cardGradients: [
      // 🐾 Животни
      _gradient(
        const Color(0xFF7C5CFC),
        const Color(0xFFA27BFF),
      ),

      // 🎨 Бои и Форми
      _gradient(
        const Color(0xFF5EA8F5),
        const Color(0xFF88C5FF),
      ),

      // 🔤 Азбука
      _gradient(
        const Color(0xFF00A896),
        const Color(0xFF20C997),
      ),

      // 🍎 Овошје и Зеленчук
      _gradient(
        const Color(0xFF43A047),
        const Color(0xFF81C784),
      ),

      // 🧩 Сите категории
      _gradient(
        const Color(0xFFE056FD),
        const Color(0xFF686DE0),
      ),
    ],

    quizGradient: _gradient(
      const Color(0xFFB85C00),
      const Color(0xFFD88400),
    ),

    textPrimary: const Color(0xFF2D3436),
    textSecondary: const Color(0xFF545E61),

    onCard: Colors.white,
    onCardSecondary: const Color(0xFFF5F5F5),

    border: const Color(0xFF6B625B),

    selected: const Color(0xFF8E3B14),
    selectedBackground: const Color(0xFFFFE0D2),

    controlBackground: Colors.white,

    correct: const Color(0xFF007A5E),
    correctBackground: const Color(0xFFD8F3EA),

    incorrect: const Color(0xFFB52B3A),
    incorrectBackground: const Color(0xFFFFE0E3),
  );

  // ================= HIGH CONTRAST =================

  static final highContrast = AccessiblePalette(
    primary: const Color(0xFF003B73),
    accent: const Color(0xFFFFB000),

    backgroundGradient: _gradient(
      Colors.white,
      const Color(0xFFFFF4C2),
    ),

    cardGradients: [
      _gradient(
        const Color(0xFF2E1065),
        const Color(0xFF5B21B6),
      ),
      _gradient(
        const Color(0xFF9A3412),
        const Color(0xFFEA580C),
      ),
      _gradient(
        const Color(0xFF005F73),
        const Color(0xFF0A9396),
      ),
      _gradient(
        const Color(0xFF166534),
        const Color(0xFF22C55E),
      ),
      _gradient(
        const Color(0xFFBE185D),
        const Color(0xFF7C3AED),
      ),
    ],

    quizGradient: _gradient(
      const Color(0xFF502000),
      const Color(0xFF8B3E00),
    ),

    textPrimary: Colors.black,
    textSecondary: const Color(0xFF252525),

    onCard: Colors.white,
    onCardSecondary: Colors.white,

    border: Colors.black,

    selected: const Color(0xFF003B73),
    selectedBackground: const Color(0xFFFFD54F),

    controlBackground: Colors.white,

    correct: const Color(0xFF005A9C),
    correctBackground: const Color(0xFFD9EEFF),

    incorrect: const Color(0xFF8A2800),
    incorrectBackground: const Color(0xFFFFDCCF),

    borderWidth: 3,
  );

  // ================= PROTANOPIA =================

  static final protanopia = AccessiblePalette(
    primary: const Color(0xFF0067A5),
    accent: const Color(0xFFE6A700),

    backgroundGradient: _gradient(
      const Color(0xFFF6FBFF),
      const Color(0xFFFFF3CF),
    ),

    cardGradients: [
      _gradient(
        const Color(0xFF235789),
        const Color(0xFF4F86C6),
      ),
      _gradient(
        const Color(0xFFCC7A00),
        const Color(0xFFFFB000),
      ),
      _gradient(
        const Color(0xFF6A4C93),
        const Color(0xFF8E72B5),
      ),
      _gradient(
        const Color(0xFF00897B),
        const Color(0xFF26A69A),
      ),
      _gradient(
        const Color(0xFF8E44AD),
        const Color(0xFF3F72AF),
      ),
    ],

    quizGradient: _gradient(
      const Color(0xFF76520A),
      const Color(0xFFA67500),
    ),

    textPrimary: const Color(0xFF17232D),
    textSecondary: const Color(0xFF3E4C56),

    onCard: Colors.white,
    onCardSecondary: const Color(0xFFF4F8FA),

    border: const Color(0xFF29495E),

    selected: const Color(0xFF004D7A),
    selectedBackground: const Color(0xFFFFE39A),

    controlBackground: Colors.white,

    correct: const Color(0xFF005F99),
    correctBackground: const Color(0xFFD8EEFC),

    incorrect: const Color(0xFF8A5B00),
    incorrectBackground: const Color(0xFFFFE8B2),

    borderWidth: 2,
  );

  // ================= DEUTERANOPIA =================

  static final deuteranopia = AccessiblePalette(
    primary: const Color(0xFF155C8A),
    accent: const Color(0xFFF0A202),

    backgroundGradient: _gradient(
      const Color(0xFFF5FAFF),
      const Color(0xFFFFF0D1),
    ),

    cardGradients: [
      _gradient(
        const Color(0xFF1D4E89),
        const Color(0xFF4F83CC),
      ),
      _gradient(
        const Color(0xFFD97706),
        const Color(0xFFFBBF24),
      ),
      _gradient(
        const Color(0xFF5E548E),
        const Color(0xFF7B6BAF),
      ),
      _gradient(
        const Color(0xFF0F766E),
        const Color(0xFF2CB1A1),
      ),
      _gradient(
        const Color(0xFFC026D3),
        const Color(0xFF4F46E5),
      ),
    ],

    quizGradient: _gradient(
      const Color(0xFF725000),
      const Color(0xFFA47400),
    ),

    textPrimary: const Color(0xFF17242E),
    textSecondary: const Color(0xFF40505A),

    onCard: Colors.white,
    onCardSecondary: const Color(0xFFF4F8FA),

    border: const Color(0xFF294C62),

    selected: const Color(0xFF0B4F78),
    selectedBackground: const Color(0xFFFFDEA0),

    controlBackground: Colors.white,

    correct: const Color(0xFF075F91),
    correctBackground: const Color(0xFFD8EEFC),

    incorrect: const Color(0xFF835600),
    incorrectBackground: const Color(0xFFFFE6AD),

    borderWidth: 2,
  );

  // ================= TRITANOPIA =================

  static final tritanopia = AccessiblePalette(
    primary: const Color(0xFF9A3E25),
    accent: const Color(0xFF00796B),

    backgroundGradient: _gradient(
      const Color(0xFFFFF8F4),
      const Color(0xFFE6F4F1),
    ),

    cardGradients: [
      _gradient(
        const Color(0xFF304E8A),
        const Color(0xFF5472D3),
      ),
      _gradient(
        const Color(0xFFC2410C),
        const Color(0xFFFF8A3D),
      ),
      _gradient(
        const Color(0xFF7B2CBF),
        const Color(0xFFA855F7),
      ),
      _gradient(
        const Color(0xFF0F766E),
        const Color(0xFF14B8A6),
      ),
      _gradient(
        const Color(0xFFDB2777),
        const Color(0xFF7C3AED),
      ),
    ],

    quizGradient: _gradient(
      const Color(0xFF803117),
      const Color(0xFFAD4D27),
    ),

    textPrimary: const Color(0xFF282126),
    textSecondary: const Color(0xFF544950),

    onCard: Colors.white,
    onCardSecondary: const Color(0xFFF8F3F5),

    border: const Color(0xFF63374C),

    selected: const Color(0xFF78321E),
    selectedBackground: const Color(0xFFD7EEE9),

    controlBackground: Colors.white,

    correct: const Color(0xFF00665B),
    correctBackground: const Color(0xFFD7EEE9),

    incorrect: const Color(0xFF8A321B),
    incorrectBackground: const Color(0xFFFFDED4),

    borderWidth: 2,
  );
}