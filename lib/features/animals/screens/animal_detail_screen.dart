import 'package:flutter/material.dart';
import '../models/animal_model.dart';
import '../../../core/accessibility/accessibility_settings.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/services/vibration_service.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/constants/typography.dart';

class AnimalDetailScreen extends StatefulWidget {
  final AnimalModel animal;

  const AnimalDetailScreen({super.key, required this.animal});

  @override
  State<AnimalDetailScreen> createState() => _AnimalDetailScreenState();
}

class _AnimalDetailScreenState extends State<AnimalDetailScreen>
    with SingleTickerProviderStateMixin {
  final _tts = TtsService();
  final _audio = AudioService();
  final _vibration = VibrationService();
  bool _isSpeaking = false;

  late AnimationController _bounceController;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bounceAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticInOut),
    );
  }

  @override
  void dispose() {
    _tts.stop();
    _bounceController.dispose();
    super.dispose();
  }

  void _speakAnimal() async {
    setState(() => _isSpeaking = true);
    _bounceController.repeat(reverse: true);

    try {
      await _audio.playAsset(widget.animal.audioPath);
      await Future.delayed(const Duration(milliseconds: 1500));
    } catch (e) {
      await _tts.speakAnimal(widget.animal.name);
      await Future.delayed(const Duration(milliseconds: 800));
      await _tts.speak(widget.animal.sound);
    }

    if (mounted) {
      setState(() => _isSpeaking = false);
      _bounceController.stop();
      _bounceController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = AccessibilityScope.of(context).palette;
    return Scaffold(
      backgroundColor: palette.backgroundGradient.colors.first,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              _buildAnimalImage(),
              _buildInfoCard(),
              _buildFunFact(),
              const SizedBox(height: 24),
              _buildSpeakButton(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final palette = AccessibilityScope.of(context).palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: palette.animalsGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: palette.onCard.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: palette.onCard,
                size: 20,
              ),
            ),
          ),
          Expanded(
            child: Text(
              widget.animal.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppTypeScale.screenTitle,
                fontWeight: FontWeight.w800,
                color: palette.onCard,
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildAnimalImage() {
    final palette = AccessibilityScope.of(context).palette;
    return Container(
      margin: const EdgeInsets.all(24),
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        color: palette.tintedSurface(palette.animalsGradient.colors.first),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: palette.border, width: palette.borderWidth),
        boxShadow: [
          BoxShadow(
            color: palette.primary.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: ScaleTransition(
          scale: _bounceAnim,
          child: Image.asset(
            widget.animal.imagePath,
            width: 180,
            height: 180,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Text(
              widget.animal.emoji,
              style: const TextStyle(fontSize: 140),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    final palette = AccessibilityScope.of(context).palette;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.controlBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.border, width: palette.borderWidth),
        boxShadow: [
          BoxShadow(
            color: palette.border.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow('🔊', 'Звук', widget.animal.sound),
          const Divider(height: 20),
          _buildInfoRow('🏡', 'Живеалиште', widget.animal.habitat),
          const Divider(height: 20),
          _buildInfoRow(
            '📂',
            'Категорија',
            _categoryLabel(widget.animal.category),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String icon, String label, String value) {
    final palette = AccessibilityScope.of(context).palette;
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: AppTypeScale.secondary,
                color: palette.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: AppTypeScale.itemTitle,
                fontWeight: FontWeight.w700,
                color: palette.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFunFact() {
    final palette = AccessibilityScope.of(context).palette;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: palette.animalsGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.border, width: palette.borderWidth),
      ),
      child: Row(
        children: [
          const Text('💡', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Дали знаеш?',
                  style: TextStyle(
                    fontSize: AppTypeScale.secondary,
                    color: palette.onCardSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.animal.funFact,
                  style: TextStyle(
                    fontSize: AppTypeScale.interactive,
                    color: palette.onCard,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeakButton() {
    final palette = AccessibilityScope.of(context).palette;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: CustomButton(
        text: _isSpeaking ? 'Слушај...' : 'Слушни ${widget.animal.name}',
        emoji: _isSpeaking ? '🔊' : '▶️',
        onTap: _isSpeaking ? () {} : _speakAnimal,
        backgroundColor: palette.animalsGradient.colors.first,
        width: double.infinity,
        height: 60,
        fontSize: AppTypeScale.itemTitle,
      ),
    );
  }

  String _categoryLabel(String cat) {
    switch (cat) {
      case 'домашно':
        return '🏠 Домашно';
      case 'дивјо':
        return '🌿 Дивјо';
      case 'птица':
        return '🐦 Птица';
      case 'море':
        return '🌊 Морско';
      default:
        return cat;
    }
  }
}
