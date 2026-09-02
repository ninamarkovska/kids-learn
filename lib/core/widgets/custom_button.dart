import 'package:flutter/material.dart';
import '../accessibility/accessibility_settings.dart';
import '../constants/typography.dart';
import '../services/vibration_service.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final double fontSize;
  final String? emoji;
  final bool shadow;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 60,
    this.borderRadius = 20,
    this.fontSize = AppTypeScale.interactive,
    this.emoji,
    this.shadow = true,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final _vibration = VibrationService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.93,
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
    final bgColor = widget.backgroundColor ?? palette.primary;

    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: palette.border,
              width: palette.borderWidth,
            ),
            boxShadow: widget.shadow
                ? [
                    BoxShadow(
                      color: bgColor.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.emoji != null) ...[
                  Text(
                    widget.emoji!,
                    style: TextStyle(fontSize: widget.fontSize),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.w700,
                    color: widget.textColor ?? palette.onCard,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
