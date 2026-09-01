enum QuizCategory { animals, colors, alphabet, all }

class QuestionModel {
  final String id;
  final String question;
  final String correctAnswer;
  final List<String> options;      // вклучувајќи го точниот
  final String emoji;
  final QuizCategory category;

  const QuestionModel({
    required this.id,
    required this.question,
    required this.correctAnswer,
    required this.options,
    required this.emoji,
    required this.category,
  });
}
