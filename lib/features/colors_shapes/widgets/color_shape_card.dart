import 'package:flutter/material.dart';
import '../models/color_shape_model.dart';
import '../../../core/services/vibration_service.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/accessibility/accessibility_settings.dart';

class ColorShapeCard extends StatefulWidget {
  final ColorShapeModel item;
  final VoidCallback onTap;

  const ColorShapeCard({super.key, required this.item, required this.onTap});

  @override
  State<ColorShapeCard> createState() => _ColorShapeCardState();
}

class _ColorShapeCardState extends State<ColorShapeCard>
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
    final light = palette.tintedSurface(widget.item.displayColor, 0.88);
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
                color: palette.border.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.item.type == ItemType.color)
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: widget.item.displayColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: palette.border.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                )
              else
                Text(widget.item.emoji, style: const TextStyle(fontSize: 50)),
              const SizedBox(height: 10),
              Text(
                widget.item.name,
                style: TextStyle(
                  fontSize: AppDimensions.cardTitleFont,
                  fontWeight: FontWeight.w800,
                  color: palette.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
