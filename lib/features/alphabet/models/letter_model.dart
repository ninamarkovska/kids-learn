class LetterModel {
  final String letter;
  final String letterLower;
  final String emoji;
  final String word;       // пример збор
  final String audioPath;
  final String imagePath;
  final String funFact;

  const LetterModel({
    required this.letter,
    required this.letterLower,
    required this.emoji,
    required this.word,
    required this.audioPath,
    required this.imagePath,
    required this.funFact,
  });
}
