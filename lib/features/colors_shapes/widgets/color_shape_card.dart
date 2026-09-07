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
      end: 0.995, // многу суптилно притискање
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
              color: widget.selected ? palette.selected : palette.border,
              width: widget.selected
                  ? palette.borderWidth + 1
                  : palette.borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: palette.border.withValues(
                  alpha: widget.selected ? 0.18 : 0.10,
                ),
                blurRadius: widget.selected ? 10 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: AnimatedScale(
                  scale: widget.selected ? 1.01 : 1.0,
                  duration: const Duration(milliseconds: 220),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // BOI
                      if (widget.item.type == ItemType.color)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          width: widget.selected ? 82 : 74,
                          height: widget.selected ? 82 : 74,
                          decoration: BoxDecoration(
                            color: widget.item.displayColor,
                            shape: BoxShape.circle,
                            // ❌ Нема бел border
                            boxShadow: [
                              BoxShadow(
                                color: palette.border.withValues(alpha: 0.18),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        )

                      // FORMI СО PNG СЛИКИ
                      else if (widget.item.id == 'triangle' ||
                          widget.item.id == 'rectangle' ||
                          widget.item.id == 'pentagon' ||
                          widget.item.id == 'hexagon')
                        SizedBox(
                          width: widget.selected ? 72 : 68,
                          height: widget.selected ? 72 : 68,
                          child: Image.asset(
                            widget.item.imagePath,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Text(
                              widget.item.emoji,
                              style: TextStyle(
                                fontSize: widget.selected ? 54 : 50,
                              ),
                            ),
                          ),
                        )

                      // ОСТАНАТИ ФОРМИ
                      else
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 220),
                          style: TextStyle(
                            fontSize: widget.selected ? 54 : 50,
                          ),
                          child: Text(widget.item.emoji),
                        ),

                      const SizedBox(height: 12),

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

              // ✔️ Ознака кога е селектирано
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