import 'package:flutter/material.dart';

import '../models/color_shape_model.dart';
import '../../../core/services/vibration_service.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/accessibility/accessibility_settings.dart';

class ColorShapeCard extends StatefulWidget {
  final ColorShapeModel item;
  final VoidCallback onTap;
  final bool selected;

  const ColorShapeCard({
    super.key,
    required this.item,
    required this.onTap,
    this.selected = false,
  });

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
      end: 0.94,
    ).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _tap() async {
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          decoration: BoxDecoration(
            color: widget.selected ? palette.selectedBackground : light,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
              widget.selected ? palette.selected : palette.border,
              width: widget.selected
                  ? palette.borderWidth + 2
                  : palette.borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: palette.border.withValues(
                  alpha: widget.selected ? 0.20 : 0.12,
                ),
                blurRadius: widget.selected ? 14 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: AnimatedScale(
                  scale: widget.selected ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 220),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.item.type == ItemType.color)
                        AnimatedContainer(
                          duration:
                          const Duration(milliseconds: 220),
                          width: widget.selected ? 60 : 56,
                          height: widget.selected ? 60 : 56,
                          decoration: BoxDecoration(
                            color: widget.item.displayColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: widget.selected ? 3 : 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: palette.border.withValues(alpha: 0.18),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                        )
                      else
                        AnimatedDefaultTextStyle(
                          duration:
                          const Duration(milliseconds: 220),
                          style: TextStyle(
                            fontSize: widget.selected ? 54 : 50,
                          ),
                          child: Text(widget.item.emoji),
                        ),
                      const SizedBox(height: 10),
                      Text(
                        widget.item.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: AppDimensions.cardTitleFont,
                          fontWeight: FontWeight.w800,
                          color: palette.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ✔️ Accessibility indicator
              if (widget.selected)
                Positioned(
                  top: 0,
                  right: 0,
                  child: AnimatedScale(
                    scale: widget.selected ? 1 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: palette.selected,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: palette.onCard,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}