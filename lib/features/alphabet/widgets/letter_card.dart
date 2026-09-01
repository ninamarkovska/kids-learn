import 'package:flutter/material.dart';
import '../models/letter_model.dart';
import '../../../core/services/vibration_service.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';

class LetterCard extends StatefulWidget {
  final LetterModel letter;
  final VoidCallback onTap;
  final int index;

  const LetterCard({
    super.key,
    required this.letter,
    required this.onTap,
    required this.index,
  });

  @override
  State<LetterCard> createState() => _LetterCardState();
}

class _LetterCardState extends State<LetterCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  final _vib = VibrationService();

  static const _colors = [
    Color(0xFF6C5CE7),
    Color(0xFF00B894),
    Color(0xFFE17055),
    Color(0xFFFF9F43),
    Color(0xFF1E90FF),
    Color(0xFFFF6EB4),
    Color(0xFF00CEC9),
    Color(0xFFFF7675),
  ];

  Color get _color => _colors[widget.index % _colors.length];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.90,
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
    final light = Color.lerp(_color, Colors.white, 0.88)!;
    return GestureDetector(
      onTap: _tap,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          decoration: BoxDecoration(
            color: light,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _color.withOpacity(0.25), width: 2),
            boxShadow: [
              BoxShadow(
                color: _color.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.letter.letter,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: _color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.letter.letterLower,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: _color.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(widget.letter.emoji, style: const TextStyle(fontSize: 34)),
              const SizedBox(height: 4),
              Text(
                widget.letter.word,
                style: TextStyle(
                  fontSize: AppTypeScale.interactive,
                  fontWeight: FontWeight.w700,
                  color: _color,
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
