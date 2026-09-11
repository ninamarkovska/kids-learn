enum QuizCategory {
  animals,
  colorsShapes,
  alphabet,
  fruitsVegetables,
  all,
}

enum QuestionType {
  animalSound,
  animalEmoji,
  animalFact,

  colorObject,
  colorEmoji,
  shapeObject,

  alphabetWord,
  alphabetLetter,

  fruitEmoji,
  fruitObject,
  vegetableEmoji,
  vegetableObject,
}

class QuestionModel {
  final String id;
  final String question;
  final String correctAnswer;
  final List<String> options;

  final String? emoji;
  final String? sound;

  final QuizCategory category;
  final QuestionType type;

  const QuestionModel({
    required this.id,
    required this.question,
    required this.correctAnswer,
    required this.options,
    this.emoji,
    this.sound,
    required this.category,
    required this.type,
  });
}