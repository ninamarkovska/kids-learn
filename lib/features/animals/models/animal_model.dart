class AnimalModel {
  final String id;
  final String name;
  final String emoji;
  final String imagePath;
  final String audioPath;
  final String sound; // Звукот на животното (мјау, лав, итн)
  final String habitat; // Живеалиште
  final String funFact; // Интересен факт
  final String category; // домашно / дивјо / птица / море

  const AnimalModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.imagePath,
    required this.audioPath,
    required this.sound,
    required this.habitat,
    required this.funFact,
    required this.category,
  });
}
