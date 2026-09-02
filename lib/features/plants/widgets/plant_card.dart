import 'package:flutter/material.dart';
import '../models/plant_model.dart';
import '../../../core/services/vibration_service.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/accessibility/accessibility_settings.dart';

class PlantCard extends StatefulWidget {
  final PlantModel plant;
  final VoidCallback onTap;
  final int index;

  const PlantCard({
    super.key,
    required this.plant,
    required this.onTap,
    required this.index,
  });

  @override
  State<PlantCard> createState() => _PlantCardState();
}

class _PlantCardState extends State<PlantCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  final _vib = VibrationService();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _tap() async {
    await _ctrl.forward();
    await _ctrl.reverse();
    _vib.lightTap();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AccessibilityScope.of(context).palette;
    final color = palette.itemAccent(widget.index);
    final light = palette.tintedSurface(color);
    return GestureDetector(
      onTap: _tap,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          decoration: BoxDecoration(
            color: light,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: palette.border,
              width: palette.borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: palette.controlBackground,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    widget.plant.imagePath,
                    width: 45,
                    height: 45,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Text(
                      widget.plant.emoji,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.plant.name,
                style: TextStyle(
                  fontSize: AppDimensions.cardTitleFont,
                  fontWeight: FontWeight.w800,
                  color: palette.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                widget.plant.category,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: palette.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
