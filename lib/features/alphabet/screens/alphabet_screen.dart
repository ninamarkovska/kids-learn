import 'package:flutter/material.dart';
import '../data/alphabet_data.dart';
import '../models/letter_model.dart';
import '../widgets/letter_card.dart';
import '../../../core/accessibility/accessibility_settings.dart';
import '../../../core/widgets/page_scaffold.dart';
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
  final _vib = VibrationService();
  final _audio = AudioService();

  LetterModel? _selected;

  bool _isBannerExpanded = false;
  bool _isMuted = false;

  Future<void> _onTap(LetterModel letter) async {
    setState(() {
      _selected = letter;
      _isBannerExpanded = false;
    });

    _vib.success();

    if (!_isMuted) {
      await _audio.playAsset(letter.audioPath);
    }
  }

  Future<void> _toggleMute() async {
    setState(() => _isMuted = !_isMuted);

    if (_isMuted) {
      await _audio.stop();
    }
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
                padding: const EdgeInsets.all(AppDimensions.learningGridPadding),
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
                  final letter = AlphabetData.letters[i];
                  return LetterCard(
                    letter: letter,
                    index: i,
                    onTap: () => _onTap(letter),
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
    final letter = _selected!;
    final palette = AccessibilityScope.of(context).palette;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: EdgeInsets.symmetric(
        horizontal: _isBannerExpanded ? 20 : 16,
        vertical: _isBannerExpanded ? 20 : 16,
      ),
      decoration: BoxDecoration(
        gradient: palette.alphabetGradient,
        border: Border.all(
          color: palette.border,
          width: palette.borderWidth,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: _isBannerExpanded ? 84 : 68,
                height: _isBannerExpanded ? 84 : 68,
                decoration: BoxDecoration(
                  color: palette.onCard.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    letter.letter,
                    style: TextStyle(
                      fontSize: _isBannerExpanded ? 50 : 38,
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
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      style: TextStyle(
                        fontSize: _isBannerExpanded ? 24 : 20,
                        fontWeight: FontWeight.w800,
                        color: palette.onCard,
                      ),
                      child: Text(
                        'Буква ${letter.letter} — за ${letter.word}',
                      ),
                    ),

                    const SizedBox(height: 6),

                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      style: TextStyle(
                        fontSize: _isBannerExpanded ? 18 : 15,
                        color: palette.onCardSecondary,
                        height: 1.4,
                      ),
                      child: Text(letter.funFact),
                    ),
                  ],
                ),
              ),

              Column(
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    style: TextStyle(
                      fontSize: _isBannerExpanded ? 46 : 36,
                    ),
                    child: Text(letter.emoji),
                  ),

                  const SizedBox(height: 8),

                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isMuted
                      ? null
                      : () => _audio.playAsset(letter.audioPath),
                  icon: const Icon(Icons.volume_up_rounded),
                  label: const Text(
                    'Слушни повторно',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: palette.primary,
                    disabledBackgroundColor: Colors.white70,
                    disabledForegroundColor: Colors.grey,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() {
                      _isBannerExpanded = !_isBannerExpanded;
                    });
                  },
                  icon: Icon(
                    _isBannerExpanded
                        ? Icons.zoom_out_rounded
                        : Icons.zoom_in_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}