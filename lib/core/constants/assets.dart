class AppAssets {
  AppAssets._();

  // Базни патеки
  static const String _imagesBase = 'assets/images';
  static const String _audioBase = 'assets/audio';

  // Животни - слики
  static const String animalsPath = '$_imagesBase/animals';

  static String animalImage(String name) => '$animalsPath/$name.png';

  // Форми - слики
  static const String shapesPath = '$_imagesBase/shapes';

  static String shapeImage(String name) => '$shapesPath/$name.png';

  // Азбука - слики
  static const String alphabetPath = '$_imagesBase/alphabet';

  static String letterImage(String letter) =>
      '$alphabetPath/letter_$letter.png';

  // Аудио - животни
  static const String animalsAudioPath = '$_audioBase/animals';

  static String animalSound(String name) => '$animalsAudioPath/$name.mp3';

  // Аудио - букви
  static const String lettersAudioPath = '$_audioBase/letters';

  static String letterSound(String letter) =>
      '$lettersAudioPath/letter_$letter.mp3';

  // Аудио - бои
  static const String colorsAudioPath = '$_audioBase/colors';

  static String colorSound(String name) => '$colorsAudioPath/$name.mp3';
}
