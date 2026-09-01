import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Основни бои
  static const Color primary = Color(0xFFFF6B35);
  static const Color secondary = Color(0xFF4ECDC4);
  static const Color accent = Color(0xFFFFE66D);
  static const Color background = Color(0xFFFFF9F0);
  static const Color white = Colors.white;

  // Текст
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textLight = Color(0xFFB2BEC3);

  // Модули
  static const Color animalsColor = Color(0xFF6C5CE7);
  static const Color animalsColorLight = Color(0xFFEDE7F6);

  static const Color colorsShapesColor = Color(0xFFE17055);
  static const Color colorsShapesColorLight = Color(0xFFFCE4EC);

  static const Color alphabetColor = Color(0xFF00B894);
  static const Color alphabetColorLight = Color(0xFFE8F5E9);

  static const Color quizColor = Color(0xFFFF9F43);
  static const Color quizColorLight = Color(0xFFFFF3E0);

  // Квиз статуси
  static const Color correct = Color(0xFF00B894);
  static const Color incorrect = Color(0xFFFF4757);
  static const Color correctLight = Color(0xFFD4EDDA);
  static const Color incorrectLight = Color(0xFFF8D7DA);

  // Бои за облици
  static const Color shapeRed = Color(0xFFFF4757);
  static const Color shapeBlue = Color(0xFF1E90FF);
  static const Color shapeGreen = Color(0xFF2ED573);
  static const Color shapeYellow = Color(0xFFFFD700);
  static const Color shapeOrange = Color(0xFFFF6348);
  static const Color shapePurple = Color(0xFF7B68EE);
  static const Color shapePink = Color(0xFFFF6EB4);
  static const Color shapeBrown = Color(0xFF8B4513);
  static const Color shapeBlack = Color(0xFF2D3436);
  static const Color shapeWhite = Color(0xFFF5F5F5);

  // Градиенти
  static const LinearGradient homeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFF9F0), Color(0xFFFFEDD8)],
  );

  static const LinearGradient animalsGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
  );

  static const LinearGradient colorsGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE17055), Color(0xFFFF9F43)],
  );

  static const LinearGradient alphabetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00B894), Color(0xFF55EFC4)],
  );

  static const LinearGradient quizGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF9F43), Color(0xFFFFD700)],
  );
}
