import 'dart:math';
import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/services/vibration_service.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/utils/helpers.dart';
import '../../animals/data/animals_data.dart';
import '../../colors_shapes/data/colors_shapes_data.dart';
import '../../alphabet/data/alphabet_data.dart';

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

  late AnimationController _shakeCtrl;
  late AnimationController _successCtrl;
  late Animation<double> _shakeAnim;
  late Animation<double> _successAnim;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _shakeAnim = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeCtrl);
    _successCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _successAnim = Tween<double>(begin: 0.8, end: 1.0)
        .animate(CurvedAnimation(parent: _successCtrl, curve: Curves.elasticOut));
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
      final wrong = AnimalsData.animals.where((x) => x.id != a.id).toList()..shuffle(_rng);
      final opts = [a.name, wrong[0].name, wrong[1].name, wrong[2].name]..shuffle(_rng);
      list.add(QuestionModel(
          id: 'a$i',
          question: 'Кое животно вака вика: "${a.sound}"?',
          correctAnswer: a.name, options: opts,
          emoji: a.emoji, category: QuizCategory.animals));
    }

    // Бои
    final cols = [...ColorsShapesData.colors]..shuffle(_rng);
    for (int i = 0; i < 6 && i < cols.length; i++) {
      final c = cols[i];
      final wrong = ColorsShapesData.colors.where((x) => x.id != c.id).toList()..shuffle(_rng);
      final opts = [c.name, wrong[0].name, wrong[1].name, wrong[2].name]..shuffle(_rng);
      list.add(QuestionModel(
          id: 'c$i',
          question: 'Која боја е ${c.description}?',
          correctAnswer: c.name, options: opts,
          emoji: c.emoji, category: QuizCategory.colors));
    }

    // Форми
    final shps = [...ColorsShapesData.shapes]..shuffle(_rng);
    for (int i = 0; i < 4 && i < shps.length; i++) {
      final s = shps[i];
      final wrong = ColorsShapesData.shapes.where((x) => x.id != s.id).toList()..shuffle(_rng);
      final opts = [s.name, wrong[0].name, wrong[1].name, wrong[2].name]..shuffle(_rng);
      list.add(QuestionModel(
          id: 's$i',
          question: 'Форма со ${s.description}?',
          correctAnswer: s.name, options: opts,
          emoji: s.emoji, category: QuizCategory.colors));
    }

    // Азбука
    final lts = [...AlphabetData.letters]..shuffle(_rng);

    for (int i = 0; i < 6 && i < lts.length; i++) {
      final l = lts[i];

      final wrong = AlphabetData.letters
          .where((x) => x.letter != l.letter)
          .toList()
        ..shuffle(_rng);

      final opts = [
        l.letter,
        wrong[0].letter,
        wrong[1].letter,
        wrong[2].letter,
      ]..shuffle(_rng);

      list.add(QuestionModel(
        id: 'l$i',
        question: 'Со која буква започнува зборот "${l.word}"?',
        correctAnswer: l.letter,
        options: opts,
        emoji: l.emoji,
        category: QuizCategory.alphabet,
      ));
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
      _tts.speak('Не е точно. Точниот одговор е ${_questions[_current].correctAnswer}');
    }
  }

  void _next() {
    if (_current + 1 >= _questions.length) {
      setState(() => _finished = true);
      _tts.speak(AppHelpers.getScoreMessage(_score, _questions.length));
    } else {
      setState(() { _current++; _selected = null; _answered = false; });
      _successCtrl.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _finished ? _buildResult() : _buildQuestion(),
      ),
    );
  }

  Widget _buildQuestion() {
    final q = _questions[_current];
    return Column(children: [
      _buildHeader(),
      _buildProgress(),
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            _buildQuestionCard(q),
            const SizedBox(height: 24),
            _buildOptions(q),
            if (_answered) ...[
              const SizedBox(height: 20),
              _buildFeedback(q),
              const SizedBox(height: 16),
              CustomButton(
                  text: _current + 1 >= _questions.length ? 'Резултат 🏆' : 'Следно →',
                  onTap: _next,
                  backgroundColor: AppColors.quizColor,
                  width: double.infinity),
            ],
          ]),
        ),
      ),
    ]);
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          gradient: AppColors.quizGradient,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24))),
      child: Row(children: [
        GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.close_rounded, color: Colors.white))),
        const Expanded(
            child: Text('🧠 Квиз', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white))),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(12)),
            child: Text('⭐ $_score',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white))),
      ]),
    );
  }

  Widget _buildProgress() {
    final progress = (_current + 1) / _questions.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Прашање ${_current + 1} од ${_questions.length}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          Text('${(progress * 100).round()}%',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.quizColor)),
        ]),
        const SizedBox(height: 8),
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
                value: progress, minHeight: 10,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation(AppColors.quizColor))),
      ]),
    );
  }

  Widget _buildQuestionCard(QuestionModel q) {
    return AnimatedBuilder(
      animation: _shakeAnim,
      builder: (_, child) => Transform.translate(
          offset: Offset(_shakeAnim.value * ((_current % 2 == 0) ? 1 : -1), 0),
          child: child),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            gradient: AppColors.quizGradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(
                color: AppColors.quizColor.withOpacity(0.3),
                blurRadius: 16, offset: const Offset(0, 6))]),
        child: Column(children: [
          Text(q.emoji, style: const TextStyle(fontSize: 72)),
          const SizedBox(height: 12),
          Text(q.question,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
              textAlign: TextAlign.center),
        ]),
      ),
    );
  }

  Widget _buildOptions(QuestionModel q) {
    return GridView.count(
      crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.8,
      children: q.options.map((opt) => _buildOptionBtn(opt, q)).toList(),
    );
  }

  Widget _buildOptionBtn(String opt, QuestionModel q) {
    Color bg = Colors.white;
    Color border = Colors.grey.shade200;
    Color text = AppColors.textPrimary;

    if (_answered) {
      if (opt == q.correctAnswer) {
        bg = AppColors.correctLight; border = AppColors.correct; text = AppColors.correct;
      } else if (opt == _selected) {
        bg = AppColors.incorrectLight; border = AppColors.incorrect; text = AppColors.incorrect;
      }
    }

    return GestureDetector(
      onTap: () => _answer(opt),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
            color: bg, borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border, width: 2),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))]),
        child: Center(child: Text(opt,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: text),
            textAlign: TextAlign.center)),
      ),
    );
  }

  Widget _buildFeedback(QuestionModel q) {
    final correct = _selected == q.correctAnswer;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
          color: correct ? AppColors.correctLight : AppColors.incorrectLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: correct ? AppColors.correct : AppColors.incorrect, width: 2)),
      child: Row(children: [
        Text(correct ? '✅' : '❌', style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 12),
        Expanded(child: Text(
            correct ? 'Точно! Браво!' : 'Точниот одговор е: ${q.correctAnswer}',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                color: correct ? AppColors.correct : AppColors.incorrect))),
      ]),
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
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                  gradient: AppColors.quizGradient,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(
                      color: AppColors.quizColor.withOpacity(0.4),
                      blurRadius: 20, spreadRadius: 4)]),
              child: Text(emoji, style: const TextStyle(fontSize: 64))),
          const SizedBox(height: 28),
          const Text('Квизот заврши!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          RichText(text: TextSpan(children: [
            TextSpan(text: '$_score',
                style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w900, color: AppColors.quizColor)),
            TextSpan(text: ' / $total',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          ])),
          const SizedBox(height: 8),
          Text('$pct% точни одговори',
              style: const TextStyle(fontSize: 16, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
          const SizedBox(height: 20),
          Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: AppColors.quizColorLight,
                  borderRadius: BorderRadius.circular(18)),
              child: Text(msg,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.quizColor),
                  textAlign: TextAlign.center)),
          const SizedBox(height: 32),
          CustomButton(
              text: 'Играј Повторно', emoji: '🔄',
              onTap: () => setState(() {
                _questions = _buildQuestions();
                _current = 0; _score = 0;
                _selected = null; _answered = false; _finished = false;
              }),
              backgroundColor: AppColors.quizColor, width: double.infinity),
          const SizedBox(height: 14),
          CustomButton(
              text: 'Дома', emoji: '🏠',
              onTap: () => Navigator.pop(context),
              backgroundColor: Colors.white,
              textColor: AppColors.textPrimary,
              width: double.infinity, shadow: false),
        ]),
      ),
    );
  }
}
