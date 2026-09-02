import 'dart:math';
import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../../../core/accessibility/accessibility_settings.dart';
import '../../../core/accessibility/accessible_palette.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/services/vibration_service.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/utils/helpers.dart';
import '../../animals/data/animals_data.dart';
import '../../colors_shapes/data/colors_shapes_data.dart';
import '../../alphabet/data/alphabet_data.dart';
import '../../../core/constants/typography.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  final _tts = TtsService();
  final _vib = VibrationService();
  final _rng = Random();

  late List<QuestionModel> _questions;
  int _current = 0;
  int _score = 0;
  String? _selected;
  bool _answered = false;
  bool _finished = false;

  AccessiblePalette get _palette => AccessibilityScope.of(context).palette;

  late AnimationController _shakeCtrl;
  late AnimationController _successCtrl;
  late Animation<double> _shakeAnim;
  late Animation<double> _successAnim;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = Tween<double>(
      begin: 0,
      end: 10,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeCtrl);
    _successCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _successAnim = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _successCtrl, curve: Curves.elasticOut));
    _questions = _buildQuestions();
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    _successCtrl.dispose();
    super.dispose();
  }

  List<QuestionModel> _buildQuestions() {
    final list = <QuestionModel>[];

    // Животни
    final animals = [...AnimalsData.animals]..shuffle(_rng);
    for (int i = 0; i < 8 && i < animals.length; i++) {
      final a = animals[i];
      final wrong = AnimalsData.animals.where((x) => x.id != a.id).toList()
        ..shuffle(_rng);
      final opts = [a.name, wrong[0].name, wrong[1].name, wrong[2].name]
        ..shuffle(_rng);
      list.add(
        QuestionModel(
          id: 'a$i',
          question: 'Кое животно вака вика: "${a.sound}"?',
          correctAnswer: a.name,
          options: opts,
          emoji: a.emoji,
          category: QuizCategory.animals,
        ),
      );
    }

    // Бои
    final cols = [...ColorsShapesData.colors]..shuffle(_rng);
    for (int i = 0; i < 6 && i < cols.length; i++) {
      final c = cols[i];
      final wrong = ColorsShapesData.colors.where((x) => x.id != c.id).toList()
        ..shuffle(_rng);
      final opts = [c.name, wrong[0].name, wrong[1].name, wrong[2].name]
        ..shuffle(_rng);
      list.add(
        QuestionModel(
          id: 'c$i',
          question: 'Која боја е ${c.description}?',
          correctAnswer: c.name,
          options: opts,
          emoji: c.emoji,
          category: QuizCategory.colors,
        ),
      );
    }

    // Форми
    final shps = [...ColorsShapesData.shapes]..shuffle(_rng);
    for (int i = 0; i < 4 && i < shps.length; i++) {
      final s = shps[i];
      final wrong = ColorsShapesData.shapes.where((x) => x.id != s.id).toList()
        ..shuffle(_rng);
      final opts = [s.name, wrong[0].name, wrong[1].name, wrong[2].name]
        ..shuffle(_rng);
      list.add(
        QuestionModel(
          id: 's$i',
          question: 'Форма со ${s.description}?',
          correctAnswer: s.name,
          options: opts,
          emoji: s.emoji,
          category: QuizCategory.colors,
        ),
      );
    }

    // Азбука
    final lts = [...AlphabetData.letters]..shuffle(_rng);

    for (int i = 0; i < 6 && i < lts.length; i++) {
      final l = lts[i];

      final wrong =
          AlphabetData.letters.where((x) => x.letter != l.letter).toList()
            ..shuffle(_rng);

      final opts = [l.letter, wrong[0].letter, wrong[1].letter, wrong[2].letter]
        ..shuffle(_rng);

      list.add(
        QuestionModel(
          id: 'l$i',
          question: 'Со која буква започнува зборот "${l.word}"?',
          correctAnswer: l.letter,
          options: opts,
          emoji: l.emoji,
          category: QuizCategory.alphabet,
        ),
      );
    }

    list.shuffle(_rng);
    return list.take(15).toList();
  }

  void _answer(String option) {
    if (_answered) return;
    final correct = option == _questions[_current].correctAnswer;
    setState(() {
      _selected = option;
      _answered = true;
      if (correct) _score++;
    });
    if (correct) {
      _vib.success();
      _successCtrl.forward(from: 0);
      _tts.speak('Точно!');
    } else {
      _vib.error();
      _shakeCtrl.forward(from: 0).then((_) => _shakeCtrl.reset());
      _tts.speak(
        'Не е точно. Точниот одговор е ${_questions[_current].correctAnswer}',
      );
    }
  }

  void _next() {
    if (_current + 1 >= _questions.length) {
      setState(() => _finished = true);
      _tts.speak(AppHelpers.getScoreMessage(_score, _questions.length));
    } else {
      setState(() {
        _current++;
        _selected = null;
        _answered = false;
      });
      _successCtrl.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _palette.backgroundGradient.colors.first,
      body: SafeArea(child: _finished ? _buildResult() : _buildQuestion()),
    );
  }

  Widget _buildQuestion() {
    final q = _questions[_current];
    return Column(
      children: [
        _buildHeader(),
        _buildProgress(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildQuestionCard(q),
                const SizedBox(height: 24),
                _buildOptions(q),
                if (_answered) ...[
                  const SizedBox(height: 20),
                  _buildFeedback(q),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: _current + 1 >= _questions.length
                        ? 'Резултат 🏆'
                        : 'Следно →',
                    onTap: _next,
                    backgroundColor: _palette.primary,
                    width: double.infinity,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: _palette.quizGradient,
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
                color: _palette.onCard.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.close_rounded, color: _palette.onCard),
            ),
          ),
          Expanded(
            child: Text(
              '🧠 Квиз',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppTypeScale.screenTitle,
                fontWeight: FontWeight.w800,
                color: _palette.onCard,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _palette.onCard.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '⭐ $_score',
              style: TextStyle(
                fontSize: AppTypeScale.itemTitle,
                fontWeight: FontWeight.w800,
                color: _palette.onCard,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    final progress = (_current + 1) / _questions.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Прашање ${_current + 1} од ${_questions.length}',
                style: TextStyle(
                  fontSize: AppTypeScale.body,
                  fontWeight: FontWeight.w600,
                  color: _palette.textSecondary,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(
                  fontSize: AppTypeScale.body,
                  fontWeight: FontWeight.w700,
                  color: _palette.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: _palette.selectedBackground,
              valueColor: AlwaysStoppedAnimation(_palette.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(QuestionModel q) {
    return AnimatedBuilder(
      animation: _shakeAnim,
      builder: (_, child) => Transform.translate(
        offset: Offset(_shakeAnim.value * ((_current % 2 == 0) ? 1 : -1), 0),
        child: child,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: _palette.quizGradient,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _palette.border,
            width: _palette.borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: _palette.primary.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(q.emoji, style: const TextStyle(fontSize: 72)),
            const SizedBox(height: 12),
            Text(
              q.question,
              style: TextStyle(
                fontSize: AppTypeScale.sectionTitle,
                fontWeight: FontWeight.w800,
                color: _palette.onCard,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptions(QuestionModel q) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.0,
      children: q.options.map((opt) => _buildOptionBtn(opt, q)).toList(),
    );
  }

  Widget _buildOptionBtn(String opt, QuestionModel q) {
    Color bg = _palette.controlBackground;
    Color border = _palette.border;
    Color text = _palette.textPrimary;

    if (_answered) {
      if (opt == q.correctAnswer) {
        bg = _palette.correctBackground;
        border = _palette.correct;
        text = _palette.correct;
      } else if (opt == _selected) {
        bg = _palette.incorrectBackground;
        border = _palette.incorrect;
        text = _palette.incorrect;
      }
    }

    return GestureDetector(
      onTap: () => _answer(opt),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 2),
          boxShadow: [
            BoxShadow(
              color: _palette.border.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Center(
            child: Text(
              opt,
              style: TextStyle(
                fontSize: AppTypeScale.interactive,
                fontWeight: FontWeight.w700,
                color: text,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedback(QuestionModel q) {
    final correct = _selected == q.correctAnswer;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: correct
            ? _palette.correctBackground
            : _palette.incorrectBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: correct ? _palette.correct : _palette.incorrect,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Text(correct ? '✅' : '❌', style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              correct
                  ? 'Точно! Браво!'
                  : 'Точниот одговор е: ${q.correctAnswer}',
              style: TextStyle(
                fontSize: AppTypeScale.interactive,
                fontWeight: FontWeight.w700,
                color: correct ? _palette.correct : _palette.incorrect,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final total = _questions.length;
    final msg = AppHelpers.getScoreMessage(_score, total);
    final emoji = AppHelpers.getScoreEmoji(_score, total);
    final pct = (_score / total * 100).round();

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: _palette.quizGradient,
                border: Border.all(
                  color: _palette.border,
                  width: _palette.borderWidth,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _palette.primary.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 64)),
            ),
            const SizedBox(height: 28),
            Text(
              'Квизот заврши!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: _palette.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$_score',
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: _palette.primary,
                    ),
                  ),
                  TextSpan(
                    text: ' / $total',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: _palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$pct% точни одговори',
              style: TextStyle(
                fontSize: AppTypeScale.itemTitle,
                color: _palette.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _palette.selectedBackground,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: _palette.border,
                  width: _palette.borderWidth,
                ),
              ),
              child: Text(
                msg,
                style: TextStyle(
                  fontSize: AppTypeScale.sectionTitle,
                  fontWeight: FontWeight.w700,
                  color: _palette.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Играј Повторно',
              emoji: '🔄',
              onTap: () => setState(() {
                _questions = _buildQuestions();
                _current = 0;
                _score = 0;
                _selected = null;
                _answered = false;
                _finished = false;
              }),
              backgroundColor: _palette.primary,
              width: double.infinity,
            ),
            const SizedBox(height: 14),
            CustomButton(
              text: 'Дома',
              emoji: '🏠',
              onTap: () => Navigator.pop(context),
              backgroundColor: _palette.controlBackground,
              textColor: _palette.textPrimary,
              width: double.infinity,
              shadow: false,
            ),
          ],
        ),
      ),
    );
  }
}
