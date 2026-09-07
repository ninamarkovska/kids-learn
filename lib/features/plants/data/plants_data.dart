import '../models/plant_model.dart';

class PlantsData {
  static const List<PlantModel> plants = [

    // 🍎 ОВОШЈЕ

    PlantModel(
      id: 'apple',
      name: 'Јаболко',
      emoji: '🍎',
      imagePath: 'assets/images/plants/apple.png',
      audioPath: 'audio/plants/apple.mp3',
      category: 'овошје',
      habitat: 'Градина',
      funFact: 'Јаболкото расте на дрво и има многу витамини!',
    ),

    PlantModel(
      id: 'banana',
      name: 'Банана',
      emoji: '🍌',
      imagePath: 'assets/images/plants/banana.png',
      audioPath: 'audio/plants/banana.mp3',
      category: 'овошје',
      habitat: 'Тропски предели',
      funFact: 'Бананата расте на големо тревесто растение, а не на дрво!',
    ),

    PlantModel(
      id: 'grape',
      name: 'Грозје',
      emoji: '🍇',
      imagePath: 'assets/images/plants/grape.png',
      audioPath: 'audio/plants/grape.mp3',
      category: 'овошје',
      habitat: 'Лозје',
      funFact: 'Грозјето расте во гроздови на лозница.',
    ),

    PlantModel(
      id: 'strawberry',
      name: 'Јагода',
      emoji: '🍓',
      imagePath: 'assets/images/plants/strawberry.png',
      audioPath: 'audio/plants/strawberry.mp3',
      category: 'овошје',
      habitat: 'Градина',
      funFact: 'Јагодата е единственото овошје со семки однадвор!',
    ),

    PlantModel(
      id: 'watermelon',
      name: 'Лубеница',
      emoji: '🍉',
      imagePath: 'assets/images/plants/watermelon.png',
      audioPath: 'audio/plants/watermelon.mp3',
      category: 'овошје',
      habitat: 'Поле',
      funFact: 'Лубеницата е околу 92% вода.',
    ),

    PlantModel(
      id: 'orange',
      name: 'Портокал',
      emoji: '🍊',
      imagePath: 'assets/images/plants/orange.png',
      audioPath: 'audio/plants/orange.mp3',
      category: 'овошје',
      habitat: 'Топли краишта',
      funFact: 'Портокалот е богат со витамин Ц.',
    ),

    PlantModel(
      id: 'tangerine',
      name: 'Мандарина',
      emoji: '🍊',
      imagePath: 'assets/images/plants/tangerine.png',
      audioPath: 'audio/plants/tangerine.mp3',
      category: 'овошје',
      habitat: 'Топли краишта',
      funFact: 'Мандарината лесно се лупи и е многу сочна.',
    ),

    PlantModel(
      id: 'lemon',
      name: 'Лимон',
      emoji: '🍋',
      imagePath: 'assets/images/plants/lemon.png',
      audioPath: 'audio/plants/lemon.mp3',
      category: 'овошје',
      habitat: 'Топли краишта',
      funFact: 'Лимонот има кисел вкус и е богат со витамин Ц.',
    ),

    PlantModel(
      id: 'pear',
      name: 'Круша',
      emoji: '🍐',
      imagePath: 'assets/images/plants/pear.png',
      audioPath: 'audio/plants/pear.mp3',
      category: 'овошје',
      habitat: 'Градина',
      funFact: 'Крушата има форма како солза и е многу сочна.',
    ),

    PlantModel(
      id: 'peach',
      name: 'Праска',
      emoji: '🍑',
      imagePath: 'assets/images/plants/peach.png',
      audioPath: 'audio/plants/peach.mp3',
      category: 'овошје',
      habitat: 'Градина',
      funFact: 'Праската има мека и кадифена кора.',
    ),

    PlantModel(
      id: 'apricot',
      name: 'Кајсија',
      emoji: '🟠',
      imagePath: 'assets/images/plants/apricot.png',
      audioPath: 'audio/plants/apricot.mp3',
      category: 'овошје',
      habitat: 'Градина',
      funFact: 'Кајсијата е слатко овошје богато со витамин А.',
    ),

    PlantModel(
      id: 'cherry',
      name: 'Цреша',
      emoji: '🍒',
      imagePath: 'assets/images/plants/cherry.png',
      audioPath: 'audio/plants/cherry.mp3',
      category: 'овошје',
      habitat: 'Градина',
      funFact: 'Црешата цвета рано напролет.',
    ),

    PlantModel(
      id: 'sour_cherry',
      name: 'Вишна',
      emoji: '🍒',
      imagePath: 'assets/images/plants/sour_cherry.png',
      audioPath: 'audio/plants/sour_cherry.mp3',
      category: 'овошје',
      habitat: 'Градина',
      funFact: 'Вишната е покисела од црешата и често се користи за сокови и колачи.',
    ),

// 🥕 ЗЕЛЕНЧУК

    PlantModel(
      id: 'carrot',
      name: 'Морков',
      emoji: '🥕',
      imagePath: 'assets/images/plants/carrot.png',
      audioPath: 'audio/plants/carrot.mp3',
      category: 'зеленчук',
      habitat: 'Градина',
      funFact: 'Морковот расте под земја и е богат со витамин А.',
    ),

    PlantModel(
      id: 'cucumber',
      name: 'Краставица',
      emoji: '🥒',
      imagePath: 'assets/images/plants/cucumber.png',
      audioPath: 'audio/plants/cucumber.mp3',
      category: 'зеленчук',
      habitat: 'Градина',
      funFact: 'Краставицата содржи многу вода и е многу освежителна.',
    ),

    PlantModel(
      id: 'onion',
      name: 'Кромид',
      emoji: '🧅',
      imagePath: 'assets/images/plants/onion.png',
      audioPath: 'audio/plants/onion.mp3',
      category: 'зеленчук',
      habitat: 'Градина',
      funFact: 'Кромидот расте под земја и има многу слоеви.',
    ),

    PlantModel(
      id: 'cauliflower',
      name: 'Карфиол',
      emoji: '🥦',
      imagePath: 'assets/images/plants/cauliflower.png',
      audioPath: 'audio/plants/cauliflower.mp3',
      category: 'зеленчук',
      habitat: 'Градина',
      funFact: 'Карфиолот е бел зеленчук богат со витамини.',
    ),

    PlantModel(
      id: 'cabbage',
      name: 'Зелка',
      emoji: '🥬',
      imagePath: 'assets/images/plants/cabbage.png',
      audioPath: 'audio/plants/cabbage.mp3',
      category: 'зеленчук',
      habitat: 'Градина',
      funFact: 'Зелката има многу зелени листови и расте во градина.',
    ),

    PlantModel(
      id: 'lettuce',
      name: 'Марула',
      emoji: '🥬',
      imagePath: 'assets/images/plants/lettuce.png',
      audioPath: 'audio/plants/lettuce.mp3',
      category: 'зеленчук',
      habitat: 'Градина',
      funFact: 'Марулата има меки зелени листови и често се јаде во салата.',
    ),

    PlantModel(
      id: 'spinach',
      name: 'Спанаќ',
      emoji: '🥬',
      imagePath: 'assets/images/plants/spinach.png',
      audioPath: 'audio/plants/spinach.mp3',
      category: 'зеленчук',
      habitat: 'Градина',
      funFact: 'Спанаќот е богат со железо и има темнозелени листови.',
    ),

    PlantModel(
      id: 'peas',
      name: 'Грашок',
      emoji: '🫛',
      imagePath: 'assets/images/plants/peas.png',
      audioPath: 'audio/plants/peas.mp3',
      category: 'зеленчук',
      habitat: 'Градина',
      funFact: 'Грашокот расте во зелени мешунки со мали зрнца.',
    ),

    PlantModel(
      id: 'corn',
      name: 'Пченка',
      emoji: '🌽',
      imagePath: 'assets/images/plants/corn.png',
      audioPath: 'audio/plants/corn.mp3',
      category: 'зеленчук',
      habitat: 'Поле',
      funFact: 'Пченката расте на високо растение и има многу жолти зрна.',
    ),

    PlantModel(
      id: 'beetroot',
      name: 'Цвекло',
      emoji: '🫜',
      imagePath: 'assets/images/plants/beetroot.png',
      audioPath: 'audio/plants/beetroot.mp3',
      category: 'зеленчук',
      habitat: 'Градина',
      funFact: 'Цвеклото расте под земја и има темноцрвена боја.',
    ),

  ];

  static List<String> get categories =>
      plants.map((p) => p.category).toSet().toList();

  static List<PlantModel> getByCategory(String category) =>
      plants.where((p) => p.category == category).toList();
}