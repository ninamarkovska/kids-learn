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

  Color itemAccent(int index) {
    final colors = cardGradients.expand((gradient) => gradient.colors).toList();
    return colors[index % colors.length];
  }

  Color tintedSurface(Color accent, [double amount = 0.85]) =>
      Color.lerp(accent, controlBackground, amount)!;
}

class AccessiblePalettes {
  AccessiblePalettes._();

  static LinearGradient _gradient(Color first, Color second) => LinearGradient(
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

  static final standard = AccessiblePalette(
    primary: const Color(0xFFFF6B35),
    accent: const Color(0xFF4ECDC4),
    backgroundGradient: _gradient(
      const Color(0xFFFFF9F0),
      const Color(0xFFFFEDD8),
    ),
    cardGradients: [
      _gradient(const Color(0xFF6C5CE7), const Color(0xFF8F83F3)),
      _gradient(const Color(0xFFC95135), const Color(0xFFE67E22)),
      _gradient(const Color(0xFF007E65), const Color(0xFF00A884)),
      _gradient(const Color(0xFF087F75), const Color(0xFF17A668)),
    ],
    quizGradient: _gradient(const Color(0xFFB85C00), const Color(0xFFD88400)),
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

  static final highContrast = AccessiblePalette(
    primary: const Color(0xFF003B73),
    accent: const Color(0xFFFFB000),
    backgroundGradient: _gradient(
      const Color(0xFFFFFFFF),
      const Color(0xFFFFF2BF),
    ),
    cardGradients: [
      _gradient(const Color(0xFF24105C), const Color(0xFF4A2C91)),
      _gradient(const Color(0xFF004F6D), const Color(0xFF00789E)),
      _gradient(const Color(0xFF6B2D00), const Color(0xFF984600)),
      _gradient(const Color(0xFF154D16), const Color(0xFF267329)),
    ],
    quizGradient: _gradient(const Color(0xFF502000), const Color(0xFF8B3E00)),
    textPrimary: const Color(0xFF111111),
    textSecondary: const Color(0xFF252525),
    onCard: Colors.white,
    onCardSecondary: Colors.white,
    border: const Color(0xFF111111),
    selected: const Color(0xFF003B73),
    selectedBackground: const Color(0xFFFFD54F),
    controlBackground: Colors.white,
    correct: const Color(0xFF005A9C),
    correctBackground: const Color(0xFFD9EEFF),
    incorrect: const Color(0xFF8A2800),
    incorrectBackground: const Color(0xFFFFDCCF),
    borderWidth: 3,
  );

  // Blue, gold, purple and teal avoid red/green-only distinctions.
  static final protanopia = AccessiblePalette(
    primary: const Color(0xFF0067A5),
    accent: const Color(0xFFE6A700),
    backgroundGradient: _gradient(
      const Color(0xFFF6FBFF),
      const Color(0xFFFFF3CF),
    ),
    cardGradients: [
      _gradient(const Color(0xFF235789), const Color(0xFF3A78AD)),
      _gradient(const Color(0xFF8B5A00), const Color(0xFFBD8500)),
      _gradient(const Color(0xFF60408C), const Color(0xFF8063A6)),
      _gradient(const Color(0xFF006D77), const Color(0xFF168D96)),
    ],
    quizGradient: _gradient(const Color(0xFF76520A), const Color(0xFFA67500)),
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

  // Navy, amber, violet and cyan stay separated without red/green cues.
  static final deuteranopia = AccessiblePalette(
    primary: const Color(0xFF155C8A),
    accent: const Color(0xFFF0A202),
    backgroundGradient: _gradient(
      const Color(0xFFF5FAFF),
      const Color(0xFFFFF0D1),
    ),
    cardGradients: [
      _gradient(const Color(0xFF173F70), const Color(0xFF376996)),
      _gradient(const Color(0xFF8C5E00), const Color(0xFFBB8200)),
      _gradient(const Color(0xFF59408A), const Color(0xFF7960A3)),
      _gradient(const Color(0xFF006A7A), const Color(0xFF168899)),
    ],
    quizGradient: _gradient(const Color(0xFF725000), const Color(0xFFA47400)),
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

  // Deep blue, orange, burgundy and blue-green maximize blue/yellow separation.
  static final tritanopia = AccessiblePalette(
    primary: const Color(0xFF9A3E25),
    accent: const Color(0xFF00796B),
    backgroundGradient: _gradient(
      const Color(0xFFFFF8F4),
      const Color(0xFFE6F4F1),
    ),
    cardGradients: [
      _gradient(const Color(0xFF263B6A), const Color(0xFF405A8D)),
      _gradient(const Color(0xFF9B3F22), const Color(0xFFC45D35)),
      _gradient(const Color(0xFF6E274E), const Color(0xFF93496E)),
      _gradient(const Color(0xFF00665B), const Color(0xFF168579)),
    ],
    quizGradient: _gradient(const Color(0xFF803117), const Color(0xFFAD4D27)),
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
