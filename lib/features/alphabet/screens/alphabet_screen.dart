import 'package:flutter/material.dart';
import '../data/alphabet_data.dart';
import '../models/letter_model.dart';
import '../widgets/letter_card.dart';
import '../../../core/accessibility/accessibility_settings.dart';
import '../../../core/widgets/page_scaffold.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/services/vibration_service.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';

class AlphabetScreen extends StatefulWidget {
  const AlphabetScreen({super.key});
  @override
  State<AlphabetScreen> createState() => _AlphabetScreenState();
}

class _AlphabetScreenState extends State<AlphabetScreen> {
  final _tts = TtsService();
  final _vib = VibrationService();
  final _audio = AudioService();
  LetterModel? _selected;

  void _onTap(LetterModel letter) async {
    setState(() => _selected = letter);
    _vib.success();

    await _audio.playAsset(letter.audioPath);
    await _tts.speakLetter(letter.letter);
    await Future.delayed(const Duration(milliseconds: 600));
    await _tts.speak(letter.word);
  }

  @override
  Widget build(BuildContext context) {
    final palette = AccessibilityScope.of(context).palette;
    return PageScaffold(
      title: '🔤 Азбука',
      gradientColors: palette.alphabetGradient.colors,
      child: Column(
        children: [
          if (_selected != null) _buildBanner(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => GridView.builder(
                padding: const EdgeInsets.all(
                  AppDimensions.learningGridPadding,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: AppDimensions.responsiveColumnCount(
                    availableWidth: constraints.maxWidth,
                    minimumCardWidth: AppDimensions.alphabetCardMinWidth,
                    maxColumns: 5,
                  ),
                  crossAxisSpacing: AppDimensions.learningGridSpacing,
                  mainAxisSpacing: AppDimensions.learningGridSpacing,
                  childAspectRatio: 0.70,
                ),
                itemCount: AlphabetData.letters.length,
                itemBuilder: (_, i) {
                  final l = AlphabetData.letters[i];
                  return LetterCard(
                    letter: l,
                    index: i,
                    onTap: () => _onTap(l),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    final l = _selected!;
    final palette = AccessibilityScope.of(context).palette;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: palette.alphabetGradient,
        border: Border.all(color: palette.border, width: palette.borderWidth),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: palette.onCard.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                l.letter,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: palette.onCard,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Буква ${l.letter} - за ${l.word}',
                  style: TextStyle(
                    fontSize: AppTypeScale.itemTitle,
                    fontWeight: FontWeight.w800,
                    color: palette.onCard,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l.funFact,
                  style: TextStyle(
                    fontSize: AppTypeScale.secondary,
                    color: palette.onCardSecondary,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(l.emoji, style: const TextStyle(fontSize: 36)),
        ],
      ),
    );
  }
}
