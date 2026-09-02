import 'package:flutter/material.dart';
import '../models/animal_model.dart';
import '../../../core/accessibility/accessibility_settings.dart';
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
    final palette = AccessibilityScope.of(context).palette;
    final cardColor = palette.itemAccent(widget.index);
    final lightColor = palette.tintedSurface(cardColor);

    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          decoration: BoxDecoration(
            color: lightColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: palette.border,
              width: palette.borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: cardColor.withValues(alpha: 0.15),
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
                  color: palette.controlBackground,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: cardColor.withValues(alpha: 0.2),
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
              const SizedBox(height: 6),
              // Име
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  widget.animal.name,
                  style: TextStyle(
                    fontSize: AppDimensions.cardTitleFont,
                    fontWeight: FontWeight.w800,
                    color: palette.textPrimary,
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
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
