import 'package:flutter/material.dart';
import '../data/alphabet_data.dart';
import '../models/letter_model.dart';
import '../widgets/letter_card.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/page_scaffold.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/services/vibration_service.dart';
import '../../../core/services/audio_service.dart';


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
    return PageScaffold(
      title: '🔤 Азбука',
      gradientColors: AppColors.alphabetGradient.colors,
      child: Column(
        children: [
          if (_selected != null) _buildBanner(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.72),
              itemCount: AlphabetData.letters.length,
              itemBuilder: (_, i) {
                final l = AlphabetData.letters[i];
                return LetterCard(letter: l, index: i, onTap: () => _onTap(l));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    final l = _selected!;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.alphabetGradient,
        borderRadius: BorderRadius.circular(20)),
      child: Row(children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(16)),
          child: Center(child: Text(l.letter,
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white)))),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Буква ${l.letter} - за ${l.word}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 4),
          Text(l.funFact, style: const TextStyle(fontSize: 12, color: Colors.white70)),
        ])),
        Text(l.emoji, style: const TextStyle(fontSize: 36)),
      ]),
    );
  }
}
