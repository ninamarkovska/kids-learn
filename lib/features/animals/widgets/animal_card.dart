import 'package:flutter/material.dart';
import '../models/animal_model.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/services/vibration_service.dart';

class AnimalCard extends StatefulWidget {
  final AnimalModel animal;
  final VoidCallback onTap;
  final int index;

  const AnimalCard({
    super.key,
    required this.animal,
    required this.onTap,
    required this.index,
  });

  @override
  State<AnimalCard> createState() => _AnimalCardState();
}

class _AnimalCardState extends State<AnimalCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  final _vibration = VibrationService();

  static const _colors = [
    AppColors.animalsColor,
    Color(0xFF00CEC9),
    Color(0xFFE17055),
    Color(0xFFFF9F43),
    Color(0xFF6C5CE7),
    Color(0xFF00B894),
    Color(0xFFFF7675),
    Color(0xFF74B9FF),
  ];

  Color get _cardColor => _colors[widget.index % _colors.length];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    await _controller.forward();
    await _controller.reverse();
    _vibration.lightTap();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final lightColor = Color.lerp(_cardColor, Colors.white, 0.85)!;

    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          decoration: BoxDecoration(
            color: lightColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _cardColor.withOpacity(0.2), width: 2),
            boxShadow: [
              BoxShadow(
                color: _cardColor.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Emoji / Слика
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _cardColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    widget.animal.imagePath,
                    width: 45,
                    height: 45,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Text(
                      widget.animal.emoji,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Име
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  widget.animal.name,
                  style: TextStyle(
                    fontSize: AppDimensions.cardTitleFont,
                    fontWeight: FontWeight.w800,
                    color: _cardColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              // Звук
              Text(
                widget.animal.sound,
                style: TextStyle(
                  fontSize: AppDimensions.cardSubtitleFont,
                  fontWeight: FontWeight.w500,
                  color: _cardColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
