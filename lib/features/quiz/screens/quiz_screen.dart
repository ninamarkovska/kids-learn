import 'dart:math';
import 'package:flutter/material.dart';

import '../models/question_model.dart';

import '../../animals/data/animals_data.dart';
import '../../colors_shapes/data/colors_shapes_data.dart';
import '../../alphabet/data/alphabet_data.dart';

import '../../../core/accessibility/accessibility_settings.dart';
import '../../../core/accessibility/accessible_palette.dart';

import '../../../core/services/audio_service.dart';
import '../../../core/services/vibration_service.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/constants/typography.dart';



class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with TickerProviderStateMixin {
  final _audio = AudioService();
  final _vibration = VibrationService();

  final Random _random = Random();

  AccessiblePalette get _palette =>
      AccessibilityScope
          .of(context)
          .palette;

  QuizCategory? _selectedCategory;

  List<QuestionModel> _questions = [];

  int _currentQuestion = 0;
  int _score = 0;

  bool _answered = false;
  bool _finished = false;

  String? _selectedAnswer;

  late AnimationController _successController;
  late AnimationController _shakeController;

  late Animation<double> _successAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _successAnimation = Tween<double>(
      begin: 0.85,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _successController,
        curve: Curves.elasticOut,
      ),
    );

    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 12,
    ).animate(
      CurvedAnimation(
        parent: _shakeController,
        curve: Curves.elasticIn,
      ),
    );
  }

  @override
  void dispose() {
    _successController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _startQuiz(QuizCategory category) {
    setState(() {
      _selectedCategory = category;
      _questions = _buildQuestions(category);

      _currentQuestion = 0;
      _score = 0;
      _answered = false;
      _finished = false;
      _selectedAnswer = null;
    });
  }

  void _playSound() {
    final question = _questions[_currentQuestion];

    if (question.sound != null && question.sound!.isNotEmpty) {
      _audio.playAsset("audio/animals/${question.sound}");

    }
  }

  void _answer(String answer) {
    if (_answered) return;

    _audio.stop();

    final question = _questions[_currentQuestion];
    final correct = answer == question.correctAnswer;

    setState(() {
      _answered = true;
      _selectedAnswer = answer;

      if (correct) {
        _score++;
      }
    });

    if (correct) {
      _successController.forward(from: 0);
      _vibration.success();

      _audio.playCorrect();
    } else {
      _shakeController.forward(from: 0);
      _vibration.error();

      _audio.playWrong();
    }
  }

  void _nextQuestion() {
    if (_currentQuestion + 1 == _questions.length) {
      setState(() {
        _finished = true;
      });

      return;
    }

    setState(() {
      _currentQuestion++;
      _answered = false;
      _selectedAnswer = null;
    });

    _successController.reset();
  }

  void _restartQuiz() {
    if (_selectedCategory == null) return;

    _startQuiz(_selectedCategory!);
  }

  void _backToCategories() {
    setState(() {
      _selectedCategory = null;
      _questions.clear();

      _currentQuestion = 0;
      _score = 0;
      _answered = false;
      _finished = false;
      _selectedAnswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedCategory == null) {
      return _buildCategoryScreen();
    }

    if (_finished) {
      return _buildResultScreen();
    }

    return _buildQuizScreen();
  }

  // ================= CATEGORY SCREEN =================

  Widget _buildCategoryScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _palette.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: _palette.border.withValues(alpha: 0.35),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: _palette.textPrimary,
                          size: 24,
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Text(
                        "🧠 Квиз за учење",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: _palette.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _categoryCard(
                        emoji: "🐾",
                        title: "Животни",
                        gradient: _palette.cardGradients[0],
                        category: QuizCategory.animals,
                      ),

                      _categoryCard(
                        emoji: "🎨",
                        title: "Бои и Форми",
                        gradient: _palette.cardGradients[1],
                        category: QuizCategory.colorsShapes,
                      ),

                      _categoryCard(
                        emoji: "🔤",
                        title: "Азбука",
                        gradient: _palette.cardGradients[2],
                        category: QuizCategory.alphabet,
                      ),

                      _categoryCard(
                        emoji: "🍓",
                        title: "Овошје и\nЗеленчук",
                        gradient: _palette.cardGradients[3],
                        category: QuizCategory.fruitsVegetables,
                      ),

                      _categoryCard(
                        emoji: "✨",
                        title: "Сите\nкатегории",
                        gradient: _palette.cardGradients[4], // ✅ различна боја
                        category: QuizCategory.all,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryCard({
    required String emoji,
    required String title,
    required LinearGradient gradient,
    required QuizCategory category,
  }) {
    final mainColor = gradient.colors.first;

    Widget decoration;

    switch (category) {
      case QuizCategory.animals:
        decoration = Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.pets, size: 42, color: Colors.white24),
            SizedBox(width: 8),
            Icon(Icons.pets, size: 34, color: Colors.white24),
            SizedBox(width: 8),
            Icon(Icons.pets, size: 26, color: Colors.white24),
          ],
        );
        break;
      case QuizCategory.fruitsVegetables:
        decoration = Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("🍎", style: TextStyle(fontSize: 34)),
            SizedBox(width: 6),
            Text("🥦", style: TextStyle(fontSize: 32)),
            SizedBox(width: 6),
            Text("🍓", style: TextStyle(fontSize: 30)),
          ],
        );
        break;

      case QuizCategory.colorsShapes:
        decoration = Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.circle, size: 28, color: Colors.white24),
            SizedBox(width: 8),
            Icon(Icons.square_rounded, size: 30, color: Colors.white24),
            SizedBox(width: 8),
            Icon(Icons.change_history_rounded,
                size: 28, color: Colors.white24),
          ],
        );
        break;

      case QuizCategory.alphabet:
        decoration = const Text(
          "ABC",
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.w900,
            color: Colors.white24,
          ),
        );
        break;

      case QuizCategory.all:
        decoration = const Icon(
          Icons.auto_awesome_rounded,
          size: 110,
          color: Colors.white24,
        );
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: GestureDetector(
        onTap: () => _startQuiz(category),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 165,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: _palette.border,
              width: _palette.borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: mainColor.withValues(alpha: .25),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -5,
                top: 10,
                child: Opacity(
                  opacity: .15,
                  child: SizedBox(width: 140, child: decoration),
                ),
              ),

              Positioned(
                left: 18,
                top: 40,
                child: Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .18),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 44),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 118,
                top: 56,
                right: 90,
                child: Text(
                  title,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: category == QuizCategory.all ? 24 : 30,
                    fontWeight: FontWeight.w900,
                    color: _palette.onCard,
                    height: 1.05,
                  ),
                ),
              ),

              Positioned(
                right: 18,
                bottom: 18,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: mainColor,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= QUESTIONS =================


  List<QuestionModel> _buildQuestions(QuizCategory category) {
    final List<QuestionModel> questions = [];

    // ================== ЖИВОТНИ ==================

    final animals = [...AnimalsData.animals]..shuffle(_random);

    for (final animal in animals.take(8)) {
      if (animal.id == "giraffe" ||
          animal.id == "shark" ||
          animal.id == "octopus" ||
          animal.id == "fish" ||
          animal.id == "snake") {
        continue;
      }

      final wrongAnimals =
      AnimalsData.animals.where((e) => e.id != animal.id).toList()
        ..shuffle(_random);

      questions.add(
        QuestionModel(
          id: "sound_${animal.id}",
          question: "🐾 Слушни го звукот. Кое животно е ова?",
          correctAnswer: animal.name,
          sound: "${animal.id}_sound.mp3",
          options: [
            animal.name,
            wrongAnimals[0].name,
            wrongAnimals[1].name,
            wrongAnimals[2].name,
          ]..shuffle(_random),
          category: QuizCategory.animals,
          type: QuestionType.animalSound,
        ),
      );

      questions.add(
        QuestionModel(
          id: "emoji_${animal.id}",
          question: "Кое животно е ова?",
          correctAnswer: animal.name,
          emoji: animal.emoji,
          options: [
            animal.name,
            wrongAnimals[0].name,
            wrongAnimals[1].name,
            wrongAnimals[2].name,
          ]..shuffle(_random),
          category: QuizCategory.animals,
          type: QuestionType.animalEmoji,
        ),
      );
    }

    questions.addAll([
      QuestionModel(
        id: "rabbit_food",
        question: "🐰 Што сака да јаде зајачето?",
        correctAnswer: "Морков",
        emoji: "🐰",
        options: ["Морков", "Риба", "Леб", "Јаболко"]..shuffle(_random),
        category: QuizCategory.animals,
        type: QuestionType.animalFact,
      ),
      QuestionModel(
        id: "cow_food",
        question: "🐄 Што јаде кравата?",
        correctAnswer: "Трева",
        emoji: "🐄",
        options: ["Трева", "Риба", "Банана", "Мед"]..shuffle(_random),
        category: QuizCategory.animals,
        type: QuestionType.animalFact,
      ),
      QuestionModel(
        id: "lion_food",
        question: "🦁 Кое животно сака месо?",
        correctAnswer: "Лав",
        emoji: "🦁",
        options: ["Лав", "Зајак", "Крава", "Коњ"]..shuffle(_random),
        category: QuizCategory.animals,
        type: QuestionType.animalFact,
      ),
      QuestionModel(
        id: "duck_home",
        question: "🦆 Каде живее патката?",
        correctAnswer: "Во вода",
        emoji: "🦆",
        options: [
          "Во вода",
          "На дрво",
          "Во пештера",
          "Во куќа"
        ]
          ..shuffle(_random),
        category: QuizCategory.animals,
        type: QuestionType.animalFact,
      ),
      QuestionModel(
        id: "fish_home",
        question: "🐟 Каде живее рибата?",
        correctAnswer: "Во вода",
        emoji: "🐟",
        options: [
          "Во вода",
          "Во небо",
          "Во шума",
          "Во куќа"
        ]
          ..shuffle(_random),
        category: QuizCategory.animals,
        type: QuestionType.animalFact,
      ),
    ]);

    // ================== БОИ ==================

    questions.addAll([
      QuestionModel(
        id: "banana",
        question: "🍌 Каква боја е бананата?",
        correctAnswer: "Жолта",
        options: ["Жолта", "Зелена", "Црвена", "Сина"]..shuffle(_random),
        category: QuizCategory.colorsShapes,
        type: QuestionType.colorObject,
      ),
      QuestionModel(
        id: "apple",
        question: "🍎 Каква боја е јаболкото?",
        correctAnswer: "Црвена",
        options: ["Сина", "Црвена", "Жолта", "Розова"]..shuffle(_random),
        category: QuizCategory.colorsShapes,
        type: QuestionType.colorObject,
      ),
      QuestionModel(
        id: "grass",
        question: "🌿 Каква боја е тревата?",
        correctAnswer: "Зелена",
        options: ["Зелена", "Жолта", "Плава", "Бела"]..shuffle(_random),
        category: QuizCategory.colorsShapes,
        type: QuestionType.colorObject,
      ),
      QuestionModel(
        id: "sky",
        question: "☁️ Каква боја е небото?",
        correctAnswer: "Сина",
        options: ["Портокалова", "Сина", "Розова", "Зелена"]..shuffle(_random),
        category: QuizCategory.colorsShapes,
        type: QuestionType.colorObject,
      ),
      QuestionModel(
        id: "carrot",
        question: "🥕 Каква боја е морковот?",
        correctAnswer: "Портокалова",
        options: [
          "Портокалова",
          "Зелена",
          "Црвена",
          "Жолта"
        ]
          ..shuffle(_random),
        category: QuizCategory.colorsShapes,
        type: QuestionType.colorObject,
      ),
      QuestionModel(
        id: "sun",
        question: "☀️ Каква боја е сонцето?",
        correctAnswer: "Жолта",
        options: ["Жолта", "Црвена", "Бела", "Сина"]..shuffle(_random),
        category: QuizCategory.colorsShapes,
        type: QuestionType.colorObject,
      ),
      QuestionModel(
        id: "snow",
        question: "❄️ Каква боја е снегот?",
        correctAnswer: "Бела",
        options: ["Бела", "Сина", "Розова", "Црна"]..shuffle(_random),
        category: QuizCategory.colorsShapes,
        type: QuestionType.colorObject,
      ),
      QuestionModel(
        id: "strawberry",
        question: "🍓 Каква боја е јагодата?",
        correctAnswer: "Црвена",
        options: ["Црвена", "Виолетова", "Жолта", "Зелена"]..shuffle(_random),
        category: QuizCategory.colorsShapes,
        type: QuestionType.colorObject,
      ),
    ]);

    // ================== ФОРМИ ==================

    questions.addAll([
      QuestionModel(
        id: "ball",
        question: "⚽ На која форма личи топката?",
        correctAnswer: "Круг",
        options: ["Круг", "Квадрат", "Триаголник", "Правоаголник"]
          ..shuffle(_random),
        category: QuizCategory.colorsShapes,
        type: QuestionType.shapeObject,
      ),
      QuestionModel(
        id: "pizza",
        question: "🍕 На која форма личи парче пица?",
        correctAnswer: "Триаголник",
        options: ["Круг", "Срце", "Триаголник", "Квадрат"]
          ..shuffle(_random),
        category: QuizCategory.colorsShapes,
        type: QuestionType.shapeObject,
      ),
      QuestionModel(
        id: "window",
        question: "🪟 На која форма личи прозорец?",
        correctAnswer: "Квадрат",
        options: ["Квадрат", "Круг", "Ѕвезда", "Срце"]..shuffle(_random),
        category: QuizCategory.colorsShapes,
        type: QuestionType.shapeObject,
      ),
      QuestionModel(
        id: "book",
        question: "📚 На која форма личи книгата?",
        correctAnswer: "Правоаголник",
        options: [
          "Правоаголник",
          "Круг",
          "Триаголник",
          "Срце"
        ]
          ..shuffle(_random),
        category: QuizCategory.colorsShapes,
        type: QuestionType.shapeObject,
      ),
      QuestionModel(
        id: "heart",
        question: "❤️ Каква форма е ова?",
        correctAnswer: "Срце",
        options: ["Круг", "Срце", "Ѕвезда", "Квадрат"]..shuffle(_random),
        category: QuizCategory.colorsShapes,
        type: QuestionType.shapeObject,
      ),
      QuestionModel(
        id: "star",
        question: "⭐ Каква форма е ова?",
        correctAnswer: "Ѕвезда",
        options: ["Ѕвезда", "Срце", "Круг", "Квадрат"]..shuffle(_random),
        category: QuizCategory.colorsShapes,
        type: QuestionType.shapeObject,
      ),
    ]);

    // ================== АЗБУКА ==================

    final letters = [...AlphabetData.letters]..shuffle(_random);

    for (final letter in letters.take(10)) {
      final wrongLetters =
      AlphabetData.letters.where((e) => e.letter != letter.letter).toList()
        ..shuffle(_random);

      questions.add(
        QuestionModel(
          id: "letter_${letter.letter}",
          question: "Со која буква започнува зборот „${letter.word}“?",
          correctAnswer: letter.letter,
          emoji: letter.emoji,
          options: [
            letter.letter,
            wrongLetters[0].letter,
            wrongLetters[1].letter,
            wrongLetters[2].letter,
          ]
            ..shuffle(_random),
          category: QuizCategory.alphabet,
          type: QuestionType.alphabetWord,
        ),
      );
    }

    questions.addAll([
      QuestionModel(
        id: "apple_letter",
        question: "🍎 Со која буква започнува зборот Јаболко?",
        correctAnswer: "Ј",
        options: ["Ј", "А", "Б", "К"]..shuffle(_random),
        category: QuizCategory.alphabet,
        type: QuestionType.alphabetLetter,
      ),
      QuestionModel(
        id: "sun_letter",
        question: "☀️ Со која буква започнува зборот Сонце?",
        correctAnswer: "С",
        options: ["С", "Т", "П", "М"]..shuffle(_random),
        category: QuizCategory.alphabet,
        type: QuestionType.alphabetLetter,
      ),
      QuestionModel(
        id: "dog_letter",
        question: "🐶 Со која буква започнува зборот Куче?",
        correctAnswer: "К",
        options: ["К", "Ч", "Л", "М"]..shuffle(_random),
        category: QuizCategory.alphabet,
        type: QuestionType.alphabetLetter,
      ),
      QuestionModel(
        id: "moon_letter",
        question: "🌙 Со која буква започнува зборот Месечина?",
        correctAnswer: "М",
        options: ["М", "С", "Л", "Ј"]..shuffle(_random),
        category: QuizCategory.alphabet,
        type: QuestionType.alphabetLetter,
      ),
      QuestionModel(
        id: "fish_letter",
        question: "🐟 Со која буква започнува зборот Риба?",
        correctAnswer: "Р",
        options: ["Р", "П", "Б", "Д"]..shuffle(_random),
        category: QuizCategory.alphabet,
        type: QuestionType.alphabetLetter,
      ),
    ]);
    // ================== ОВОШЈЕ И ЗЕЛЕНЧУК ==================

    questions.addAll([
      QuestionModel(
        id: "apple_fruit",
        question: "🍎 Што е ова?",
        correctAnswer: "Јаболко",
        emoji: "🍎",
        options: ["Јаболко", "Круша", "Домат", "Портокал"]..shuffle(_random),
        category: QuizCategory.fruitsVegetables,
        type: QuestionType.fruitEmoji,
      ),

      QuestionModel(
        id: "banana_fruit",
        question: "🍌 Што е ова?",
        correctAnswer: "Банана",
        emoji: "🍌",
        options: ["Банана", "Пченка", "Лимон", "Круша"]..shuffle(_random),
        category: QuizCategory.fruitsVegetables,
        type: QuestionType.fruitEmoji,
      ),

      QuestionModel(
        id: "orange_fruit",
        question: "🍊 Што е ова?",
        correctAnswer: "Портокал",
        emoji: "🍊",
        options: ["Портокал", "Праска", "Јаболко", "Мандарина"]..shuffle(_random),
        category: QuizCategory.fruitsVegetables,
        type: QuestionType.fruitEmoji,
      ),

      QuestionModel(
        id: "strawberry_fruit",
        question: "🍓 Што е ова?",
        correctAnswer: "Јагода",
        emoji: "🍓",
        options: ["Јагода", "Цреша", "Малина", "Домат"]..shuffle(_random),
        category: QuizCategory.fruitsVegetables,
        type: QuestionType.fruitEmoji,
      ),

      QuestionModel(
        id: "carrot_vegetable",
        question: "🥕 Што е ова?",
        correctAnswer: "Морков",
        emoji: "🥕",
        options: ["Морков", "Банана", "Пченка", "Краставица"]..shuffle(_random),
        category: QuizCategory.fruitsVegetables,
        type: QuestionType.vegetableEmoji,
      ),

      QuestionModel(
        id: "broccoli_vegetable",
        question: "🥦 Што е ова?",
        correctAnswer: "Брокула",
        emoji: "🥦",
        options: ["Брокула", "Карфиол", "Зелка", "Спанаќ"]..shuffle(_random),
        category: QuizCategory.fruitsVegetables,
        type: QuestionType.vegetableEmoji,
      ),

      QuestionModel(
        id: "tomato_vegetable",
        question: "🍅 Што е ова?",
        correctAnswer: "Домат",
        emoji: "🍅",
        options: ["Домат", "Јаболко", "Пиперка", "Праска"]..shuffle(_random),
        category: QuizCategory.fruitsVegetables,
        type: QuestionType.vegetableEmoji,
      ),

      QuestionModel(
        id: "cucumber_vegetable",
        question: "🥒 Што е ова?",
        correctAnswer: "Краставица",
        emoji: "🥒",
        options: ["Краставица", "Тиквичка", "Морков", "Пченка"]..shuffle(_random),
        category: QuizCategory.fruitsVegetables,
        type: QuestionType.vegetableEmoji,
      ),
    ]);

    // ================== КАТЕГОРИИ ==================

    List<QuestionModel> filtered;

    switch (category) {
      case QuizCategory.animals:
        filtered = questions
            .where((q) => q.category == QuizCategory.animals)
            .toList();
        break;

      case QuizCategory.colorsShapes:
        filtered = questions
            .where((q) => q.category == QuizCategory.colorsShapes)
            .toList();
        break;

      case QuizCategory.alphabet:
        filtered = questions
            .where((q) => q.category == QuizCategory.alphabet)
            .toList();
        break;

      case QuizCategory.fruitsVegetables:
        filtered = questions
            .where((q) => q.category == QuizCategory.fruitsVegetables)
            .toList();
        break;

      case QuizCategory.all:
        filtered = questions;
        break;
    }

    filtered.shuffle(_random);
    return filtered.take(15).toList();

    filtered.shuffle(_random);

    return filtered.take(15).toList();
  }

  // ================= QUIZ SCREEN =================

  Widget _buildQuizScreen() {
    final question = _questions[_currentQuestion];

    return Scaffold(
      backgroundColor: _palette.backgroundGradient.colors.first,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgress(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _shakeAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                            _answered && _selectedAnswer != question.correctAnswer
                                ? sin(_shakeController.value * pi * 6) * 8
                                : 0,
                            0,
                          ),
                          child: child,
                        );
                      },
                      child: _buildQuestionCard(question),
                    ),

                    const SizedBox(height: 25),

                    if (question.sound != null && question.sound!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: SizedBox(
                          width: double.infinity,
                          height: 70,
                          child: ElevatedButton.icon(
                            onPressed: _playSound,
                            icon: const Icon(
                              Icons.volume_up_rounded,
                              size: 34,
                            ),
                            label: const Text(
                              "Слушни",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _palette.primary,
                              foregroundColor: Colors.white,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                          ),
                        ),
                      ),

                    _buildOptions(question),

                    if (_answered) ...[
                      const SizedBox(height: 20),
                      _buildFeedback(question),

                      const SizedBox(height: 20),

                      CustomButton(
                        text: _currentQuestion + 1 ==
                            _questions.length
                            ? "Резултат 🏆"
                            : "Следно ➜",
                        onTap: _nextQuestion,
                        width: double.infinity,
                        backgroundColor: _palette.primary,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// ================= HEADER =================

  Widget _buildHeader() {
    String title = "Сите категории";

    switch (_selectedCategory) {
      case QuizCategory.animals:
        title = "Животни";
        break;
      case QuizCategory.colorsShapes:
        title = "Бои и Форми";
        break;
      case QuizCategory.alphabet:
        title = "Азбука";
        break;
      case QuizCategory.all:
        title = "Сите категории";
        break;
      default:
        break;
    }

    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        gradient: _palette.quizGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _backToCategories,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.arrow_back_rounded,
                  color: Colors.white),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              "⭐ $_score",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

// ================= PROGRESS =================

  Widget _buildProgress() {
    final progress =
        (_currentQuestion + 1) / _questions.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Прашање ${_currentQuestion + 1} од ${_questions.length}",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: _palette.textSecondary,
                ),
              ),
              Text(
                "${(progress * 100).round()}%",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: _palette.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor:
              _palette.selectedBackground,
              valueColor:
              AlwaysStoppedAnimation(_palette.primary),
            ),
          ),
        ],
      ),
    );
  }

// ================= QUESTION CARD =================

  Widget _buildQuestionCard(QuestionModel question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: _palette.quizGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color:
            _palette.primary.withOpacity(.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          if (question.emoji != null)
            Text(
              question.emoji!,
              style: const TextStyle(fontSize: 75),
            ),

          const SizedBox(height: 15),

          Text(
            question.question,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

// ================= OPTIONS =================

  Widget _buildOptions(QuestionModel question) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: question.options.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 2.2,
      ),
      itemBuilder: (_, index) {
        final option = question.options[index];

        bool correct =
            option == question.correctAnswer;

        bool selected =
            option == _selectedAnswer;

        Color background =
            _palette.controlBackground;
        Color border = _palette.border;
        Color text = _palette.textPrimary;

        if (_answered) {
          if (correct) {
            background =
                _palette.correctBackground;
            border = _palette.correct;
            text = _palette.correct;
          } else if (selected) {
            background =
                _palette.incorrectBackground;
            border = _palette.incorrect;
            text = _palette.incorrect;
          }
        }

        return GestureDetector(
          onTap: () => _answer(option),
          child: AnimatedContainer(
            duration:
            const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: background,
              borderRadius:
              BorderRadius.circular(18),
              border: Border.all(
                color: border,
                width: 2,
              ),
            ),
            child: Center(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  option,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: text,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

// ================= FEEDBACK =================

  Widget _buildFeedback(QuestionModel question) {
    final correct = _selectedAnswer == question.correctAnswer;

    return AnimatedScale(
      duration: const Duration(milliseconds: 350),
      curve: Curves.elasticOut,
      scale: correct ? _successAnimation.value : 1,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: correct
              ? _palette.correctBackground
              : _palette.incorrectBackground,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: correct ? _palette.correct : _palette.incorrect,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (correct ? _palette.correct : _palette.incorrect)
                  .withValues(alpha: .15),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: (correct ? _palette.correct : _palette.incorrect)
                    .withValues(alpha: .12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                correct
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                color: correct ? _palette.correct : _palette.incorrect,
                size: 38,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    correct ? "Браво! 🌟" : "Неточен одговор",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: correct ? _palette.correct : _palette.incorrect,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    correct
                        ? "Одлично! Точен одговор."
                        : "Точниот одговор е",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _palette.textPrimary,
                      height: 1.35,
                    ),
                  ),

                  if (!correct) ...[
                    const SizedBox(height: 14),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF22C55E),
                            size: 28,
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              question.correctAnswer,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: _palette.correct,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // ================= RESULT SCREEN =================

  Widget _buildResultScreen() {
    final total = _questions.length;
    final percent = ((_score / total) * 100).round();

    String emoji = "🎉";
    String title = "Браво!";
    Color color = _palette.primary;

    if (percent == 100) {
      emoji = "🏆";
      title = "Совршен резултат!";
      color = const Color(0xFFFFC107);
    } else if (percent >= 80) {
      emoji = "🌟";
      title = "Одлично!";
      color = const Color(0xFF34C759);
    } else if (percent >= 60) {
      emoji = "😊";
      title = "Многу добро!";
      color = const Color(0xFF3B82F6);
    } else if (percent >= 40) {
      emoji = "💪";
      title = "Продолжи така!";
      color = const Color(0xFFF59E0B);
    } else {
      emoji = "❤️";
      title = "Ајде повторно!";
      color = const Color(0xFFEF4444);
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _palette.backgroundGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withValues(alpha: .15),
                        ),
                      ),

                      Container(
                        width: 130,
                        height: 130,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),

                      Text(
                        emoji,
                        style: const TextStyle(fontSize: 80),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: color,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Освои $_score од $total поени!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: _palette.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "$percent% точни одговори ⭐",
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: color, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: .15),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "⭐ Твој резултат",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 20),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: LinearProgressIndicator(
                            value: percent / 100,
                            minHeight: 18,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation(color),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          AppHelpers.getScoreMessage(_score, total),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 34),

                  CustomButton(
                    text: "🔄 Играј повторно",
                    width: double.infinity,
                    backgroundColor: _palette.primary,
                    onTap: _restartQuiz,
                  ),

                  const SizedBox(height: 14),

                  CustomButton(
                    text: "🧩 Избери друга категорија",
                    width: double.infinity,
                    backgroundColor: Colors.white,
                    textColor: _palette.textPrimary,
                    shadow: false,
                    onTap: _backToCategories,
                  ),

                  const SizedBox(height: 14),

                  CustomButton(
                    text: "🏠 Почетна",
                    width: double.infinity,
                    backgroundColor: Colors.grey.shade100,
                    textColor: _palette.textPrimary,
                    shadow: false,
                    onTap: () => Navigator.pop(context),
                  ),

                  const SizedBox(height: 30),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .75),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Продолжи да учиш и ќе бидеш уште подобар/подобра! 🌟",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _palette.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}