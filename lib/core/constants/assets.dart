class AppAssets {
  AppAssets._();

  static const String _imagesBase = 'assets/images';
  static const String _audioBase = 'assets/audio';

  static const String animalsPath = '$_imagesBase/animals';

  static String animalImage(String name) => '$animalsPath/$name.png';

  static const String shapesPath = '$_imagesBase/shapes';

  static String shapeImage(String name) => '$shapesPath/$name.png';

  static const String alphabetPath = '$_imagesBase/alphabet';

  static String letterImage(String letter) =>
      '$alphabetPath/letter_$letter.png';

  static const String animalsAudioPath = '$_audioBase/animals';

  static String animalSound(String name) => '$animalsAudioPath/$name.mp3';

  static const String lettersAudioPath = '$_audioBase/letters';

  static String letterSound(String letter) =>
      '$lettersAudioPath/letter_$letter.mp3';

  static const String colorsAudioPath = '$_audioBase/colors';

  static String colorSound(String name) => '$colorsAudioPath/$name.mp3';
}
