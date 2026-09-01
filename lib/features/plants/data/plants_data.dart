import '../models/plant_model.dart';

class PlantsData {
  static const List<PlantModel> plants = [
    // 🌸 ЦВЕТОВИ
    PlantModel(id: 'rose', name: 'Роза', emoji: '🌹', imagePath: 'assets/images/plants/rose.png', audioPath: 'audio/plants/rose.mp3', category: 'цвет', habitat: 'Градина', funFact: 'Розата е симбол на љубов низ целиот свет!'),
    PlantModel(id: 'sunflower', name: 'Сончоглед', emoji: '🌻', imagePath: 'assets/images/plants/sunflower.png', audioPath: 'audio/plants/sunflower.mp3', category: 'цвет', habitat: 'Поле', funFact: 'Сончогледот секогаш се врти кон сонцето!'),
    PlantModel(id: 'tulip', name: 'Лале', emoji: '🌷', imagePath: 'assets/images/plants/tulip.png', audioPath: 'audio/plants/tulip.mp3', category: 'цвет', habitat: 'Градина', funFact: 'Лалињата потекнуваат од Турција!'),
    PlantModel(id: 'daisy', name: 'Маргаритка', emoji: '🌼', imagePath: 'assets/images/plants/daisy.png', audioPath: 'audio/plants/daisy.mp3', category: 'цвет', habitat: 'Ливада', funFact: 'Маргаритката е симбол на чистота!'),
    PlantModel(id: 'lavender', name: 'Лаванда', emoji: '💜', imagePath: 'assets/images/plants/lavender.png', audioPath: 'audio/plants/lavender.mp3', category: 'цвет', habitat: 'Градина', funFact: 'Лавандата има убав мирис и смирува!'),
    PlantModel(id: 'lily', name: 'Крин', emoji: '🌺', imagePath: 'assets/images/plants/lily.png', audioPath: 'audio/plants/lily.mp3', category: 'цвет', habitat: 'Градина', funFact: 'Кринот е симбол на чистота и убавина!'),

    // 🍎 ОВОШЈЕ
    PlantModel(id: 'apple', name: 'Јаболко', emoji: '🍎', imagePath: 'assets/images/plants/apple.png', audioPath: 'audio/plants/apple.mp3', category: 'овошје', habitat: 'Градина', funFact: 'Јаболкото расте на дрво и има многу витамини!'),
    PlantModel(id: 'banana', name: 'Банана', emoji: '🍌', imagePath: 'assets/images/plants/banana.png', audioPath: 'audio/plants/banana.mp3', category: 'овошје', habitat: 'Тропски предели', funFact: 'Бананата расте на трева, не на дрво!'),
    PlantModel(id: 'grape', name: 'Грозје', emoji: '🍇', imagePath: 'assets/images/plants/grape.png', audioPath: 'audio/plants/grape.mp3', category: 'овошје', habitat: 'Лозје', funFact: 'Од грозје се прави сок и се јаде свежо!'),
    PlantModel(id: 'strawberry', name: 'Јагода', emoji: '🍓', imagePath: 'assets/images/plants/strawberry.png', audioPath: 'audio/plants/strawberry.mp3', category: 'овошје', habitat: 'Градина', funFact: 'Јагодата е единственото овошје со семки однадвор!'),
    PlantModel(id: 'watermelon', name: 'Лубеница', emoji: '🍉', imagePath: 'assets/images/plants/watermelon.png', audioPath: 'audio/plants/watermelon.mp3', category: 'овошје', habitat: 'Поле', funFact: 'Лубеницата е 92% вода!'),
    PlantModel(id: 'orange', name: 'Портокал', emoji: '🍊', imagePath: 'assets/images/plants/orange.png', audioPath: 'audio/plants/orange.mp3', category: 'овошје', habitat: 'Топли краишта', funFact: 'Портокалот е полн со витамин Ц!'),
    PlantModel(id: 'cherry', name: 'Цреша', emoji: '🍒', imagePath: 'assets/images/plants/cherry.png', audioPath: 'audio/plants/cherry.mp3', category: 'овошје', habitat: 'Градина', funFact: 'Црешата цвета прва во пролет!'),
    PlantModel(id: 'peach', name: 'Праска', emoji: '🍑', imagePath: 'assets/images/plants/peach.png', audioPath: 'audio/plants/peach.mp3', category: 'овошје', habitat: 'Градина', funFact: 'Праската е мека и слатка, потекнува од Кина!'),
    PlantModel(id: 'pear', name: 'Круша', emoji: '🍐', imagePath: 'assets/images/plants/pear.png', audioPath: 'audio/plants/pear.mp3', category: 'овошје', habitat: 'Градина', funFact: 'Крушата е со уникатна форма која личи на солза!'),
    PlantModel(id: 'lemon', name: 'Лимон', emoji: '🍋', imagePath: 'assets/images/plants/lemon.png', audioPath: 'audio/plants/lemon.mp3', category: 'овошје', habitat: 'Топли краишта', funFact: 'Лимонот е многу кисел но полн со витамин Ц!'),

    // 🥦 ЗЕЛЕНЧУК
    PlantModel(id: 'carrot', name: 'Морков', emoji: '🥕', imagePath: 'assets/images/plants/carrot.png', audioPath: 'audio/plants/carrot.mp3', category: 'зеленчук', habitat: 'Градина', funFact: 'Морковот расте под земјата и помага за вид!'),
    PlantModel(id: 'tomato', name: 'Домат', emoji: '🍅', imagePath: 'assets/images/plants/tomato.png', audioPath: 'audio/plants/tomato.mp3', category: 'зеленчук', habitat: 'Градина', funFact: 'Доматот е всушност овошје, не зеленчук!'),
    PlantModel(id: 'broccoli', name: 'Брокула', emoji: '🥦', imagePath: 'assets/images/plants/broccoli.png', audioPath: 'audio/plants/broccoli.mp3', category: 'зеленчук', habitat: 'Градина', funFact: 'Брокулата е полна со витамини и многу здрава!'),
    PlantModel(id: 'corn', name: 'Пченка', emoji: '🌽', imagePath: 'assets/images/plants/corn.png', audioPath: 'audio/plants/corn.mp3', category: 'зеленчук', habitat: 'Поле', funFact: 'Пченката има точно 800 зрна на секој клас!'),
    PlantModel(id: 'potato', name: 'Компир', emoji: '🥔', imagePath: 'assets/images/plants/potato.png', audioPath: 'audio/plants/potato.mp3', category: 'зеленчук', habitat: 'Градина', funFact: 'Компирот расте под земјата и е полн со енергија!'),
    PlantModel(id: 'cucumber', name: 'Краставица', emoji: '🥒', imagePath: 'assets/images/plants/cucumber.png', audioPath: 'audio/plants/cucumber.mp3', category: 'зеленчук', habitat: 'Градина', funFact: 'Краставицата е 96% вода!'),
    PlantModel(id: 'pepper', name: 'Пиперка', emoji: '🌶️', imagePath: 'assets/images/plants/pepper.png', audioPath: 'audio/plants/pepper.mp3', category: 'зеленчук', habitat: 'Градина', funFact: 'Пиперката може да биде слатка или лута!'),
    PlantModel(id: 'onion', name: 'Кромид', emoji: '🧅', imagePath: 'assets/images/plants/onion.png', audioPath: 'audio/plants/onion.mp3', category: 'зеленчук', habitat: 'Градина', funFact: 'Кромидот те тера да плачеш кога го сечеш!'),
    PlantModel(id: 'garlic', name: 'Лук', emoji: '🧄', imagePath: 'assets/images/plants/garlic.png', audioPath: 'audio/plants/garlic.mp3', category: 'зеленчук', habitat: 'Градина', funFact: 'Лукот е познат лек уште од антички времиња!'),

    // 🌳 ДРВЈА
    PlantModel(id: 'oak', name: 'Даб', emoji: '🌳', imagePath: 'assets/images/plants/oak.png', audioPath: 'audio/plants/oak.mp3', category: 'дрво', habitat: 'Шума', funFact: 'Дабот може да живее над 1000 години!'),
    PlantModel(id: 'pine', name: 'Бор', emoji: '🌲', imagePath: 'assets/images/plants/pine.png', audioPath: 'audio/plants/pine.mp3', category: 'дрво', habitat: 'Шума', funFact: 'Борот е зелен цела година, дури и зими!'),
    PlantModel(id: 'palm', name: 'Палма', emoji: '🌴', imagePath: 'assets/images/plants/palm.png', audioPath: 'audio/plants/palm.mp3', category: 'дрво', habitat: 'Тропски предели', funFact: 'Палмата расте покрај топли мориња и плажи!'),
    PlantModel(id: 'birch', name: 'Бреза', emoji: '🌿', imagePath: 'assets/images/plants/birch.png', audioPath: 'audio/plants/birch.mp3', category: 'дрво', habitat: 'Шума', funFact: 'Брезата има бела кора и е многу елегантна!'),

    // 🌵 ПОСЕБНИ
    PlantModel(id: 'cactus', name: 'Кактус', emoji: '🌵', imagePath: 'assets/images/plants/cactus.png', audioPath: 'audio/plants/cactus.mp3', category: 'посебно', habitat: 'Пустина', funFact: 'Кактусот може да чува вода со месеци!'),
    PlantModel(id: 'mushroom', name: 'Печурка', emoji: '🍄', imagePath: 'assets/images/plants/mushroom.png', audioPath: 'audio/plants/mushroom.mp3', category: 'посебно', habitat: 'Шума', funFact: 'Печурките не се растенија - тие се габи!'),
    PlantModel(id: 'grass', name: 'Трева', emoji: '🌿', imagePath: 'assets/images/plants/grass.png', audioPath: 'audio/plants/grass.mp3', category: 'посебно', habitat: 'Ливада', funFact: 'Тревата расте на скоро секое место на земјата!'),
    PlantModel(id: 'seaweed', name: 'Алга', emoji: '🌊', imagePath: 'assets/images/plants/seaweed.png', audioPath: 'audio/plants/seaweed.mp3', category: 'посебно', habitat: 'Море', funFact: 'Алгите живеат во вода и даваат кислород!'),
  ];

  static List<String> get categories =>
      plants.map((p) => p.category).toSet().toList();

  static List<PlantModel> getByCategory(String category) =>
      plants.where((p) => p.category == category).toList();
}