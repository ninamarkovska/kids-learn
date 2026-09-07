import 'package:flutter/material.dart';
import '../models/color_shape_model.dart';

class ColorsShapesData {
  static const List<ColorShapeModel> colors = [
    ColorShapeModel(
      id: 'red',
      name: 'Црвена',
      imagePath: '',
      emoji: '🔴',
      displayColor: Color(0xFFFF4757),
      type: ItemType.color,
      audioPath: 'assets/audio/colors/crvena.mp3',
      description: 'Црвени се јаболката, црешите, доматите и јагодите.',
      funFact: 'Црвената боја лесно го привлекува вниманието!',
    ),

    ColorShapeModel(
      id: 'blue',
      name: 'Сина',
      imagePath: '',
      emoji: '🔵',
      displayColor: Color(0xFF1E90FF),
      type: ItemType.color,
      audioPath: 'assets/audio/colors/sina.mp3',
      description: 'Сино е небото, морето, боичката и делфините.',
      funFact: 'Небото и морето изгледаат сини.',
    ),

    ColorShapeModel(
      id: 'yellow',
      name: 'Жолта',
      imagePath: '',
      emoji: '🟡',
      displayColor: Color(0xFFFFD700),
      type: ItemType.color,
      audioPath: 'assets/audio/colors/zolta.mp3',
      description: 'Жолто е сонцето, бананите, лимоните и крушите.',
      funFact: 'Сончевата боја е жолта!',
    ),

    ColorShapeModel(
      id: 'green',
      name: 'Зелена',
      imagePath: '',
      emoji: '🟢',
      displayColor: Color(0xFF2ED573),
      type: ItemType.color,
      audioPath: 'assets/audio/colors/zelena.mp3',
      description: 'Зелена е тревата, лубениците, лисјата и жабите.',
      funFact: 'Тревата и лисјата се зелени.',
    ),

    ColorShapeModel(
      id: 'orange',
      name: 'Портокалова',
      imagePath: '',
      emoji: '🟠',
      displayColor: Color(0xFFFF7403),
      type: ItemType.color,
      audioPath: 'assets/audio/colors/portokalova.mp3',
      description: 'Портокалови се мандарините, морковите, тиквите и портокалите.',
      funFact: 'Портокалот и морковот се портокалови.',
    ),

    ColorShapeModel(
      id: 'purple',
      name: 'Виолетова',
      imagePath: '',
      emoji: '🟣',
      displayColor: Color(0xFF7B68EE),
      type: ItemType.color,
      audioPath: 'assets/audio/colors/violetova.mp3',
      description: 'Виолетово е грозјето, пеперутките, фустаните и балоните.',
      funFact: 'Грозјето може да биде виолетово.',
    ),

    ColorShapeModel(
      id: 'pink',
      name: 'Розова',
      imagePath: '',
      emoji: '🌸',
      displayColor: Color(0xFFFF6EB4),
      type: ItemType.color,
      audioPath: 'assets/audio/colors/rozeva.mp3',
      description: 'Розови се розевиот зајко, фламингото и розовата пеперутка.',
      funFact: 'Фламингото е познато по својата розова боја.',
    ),

    ColorShapeModel(
      id: 'brown',
      name: 'Кафеава',
      imagePath: '',
      emoji: '🟫',
      displayColor: Color(0xFF8B4513),
      type: ItemType.color,
      audioPath: 'assets/audio/colors/kafena.mp3',
      description: 'Кафеави се дабарот, ежот, дивото прасе, еленот и костените.',
      funFact: 'Костените и еленот имаат кафеава боја.',
    ),

    ColorShapeModel(
      id: 'black',
      name: 'Црна',
      imagePath: '',
      emoji: '⬛',
      displayColor: Color(0xFF2D3436),
      type: ItemType.color,
      audioPath: 'assets/audio/colors/crna.mp3',
      description: 'Црно е мачето, шеширот, чоколадото и чадорот.',
      funFact: 'Ноќта изгледа црна.',
    ),

    ColorShapeModel(
      id: 'white',
      name: 'Бела',
      imagePath: '',
      emoji: '⬜',
      displayColor: Color(0xFFEEEEEE),
      type: ItemType.color,
      audioPath: 'assets/audio/colors/bela.mp3',
      description: 'Бели се снегот, млекото, облаците и зајачињата.',
      funFact: 'Снегот и облаците се бели.',
    ),
  ];

  static const List<ColorShapeModel> shapes = [
    ColorShapeModel(
      id: 'circle',
      name: 'Круг',
      imagePath: 'assets/images/shapes/circle.png',
      emoji: '⭕',
      displayColor: Color(0xFF1E90FF),
      type: ItemType.shape,
      audioPath: 'assets/audio/shapes/circle.mp3',
      description: 'Тркалезна форма без агли',
      funFact: 'Тркалото е круг - без него нема коли!',
    ),

    ColorShapeModel(
      id: 'square',
      name: 'Квадрат',
      imagePath: 'assets/images/shapes/square.png',
      emoji: '🟥',
      displayColor: Color(0xFFFF4757),
      type: ItemType.shape,
      audioPath: 'assets/audio/shapes/square.mp3',
      description: '4 еднакви страни и 4 агли',
      funFact: 'Скоро сите прозорци се квадрати!',
    ),

    ColorShapeModel(
      id: 'triangle',
      name: 'Триаголник',
      imagePath: 'assets/images/shapes/triangle.png',
      emoji: '🔺',
      displayColor: Color(0xFFFF9F43),
      type: ItemType.shape,
      audioPath: 'assets/audio/shapes/triangle.mp3',
      description: '3 страни и 3 агли',
      funFact: 'Пирамидите во Египет се триаголници!',
    ),

    ColorShapeModel(
      id: 'rectangle',
      name: 'Правоаголник',
      imagePath: 'assets/images/shapes/rectangle.png',
      emoji: '🟦',
      displayColor: Color(0xFF6C5CE7),
      type: ItemType.shape,
      audioPath: 'assets/audio/shapes/rectangle.mp3',
      description: '4 страни, 2 долги и 2 кратки',
      funFact: 'Вратата на твојата соба е правоаголник!',
    ),

    ColorShapeModel(
      id: 'star',
      name: 'Ѕвезда',
      imagePath: 'assets/images/shapes/star.png',
      emoji: '⭐',
      displayColor: Color(0xFFFFD700),
      type: ItemType.shape,
      audioPath: 'assets/audio/shapes/star.mp3',
      description: '5 краци, симбол на светло',
      funFact: 'На небото има многу ѕвезди!',
    ),

    ColorShapeModel(
      id: 'pentagon',
      name: 'Петтоаголник',
      imagePath: 'assets/images/shapes/pentagon.png',
      emoji: '⬟',
      displayColor: Color(0xFFFF9F43),
      type: ItemType.shape,
      audioPath: 'assets/audio/shapes/pentagon.mp3',
      description: 'Форма со 5 страни',
      funFact: 'Петтоаголникот има пет страни и пет агли.',
    ),

    ColorShapeModel(
      id: 'hexagon',
      name: 'Шестоаголник',
      imagePath: 'assets/images/shapes/hexagon.png',
      emoji: '⬢',
      displayColor: Color(0xFF6C5CE7),
      type: ItemType.shape,
      audioPath: 'assets/audio/shapes/hexagon.mp3',
      description: 'Форма со 6 страни',
      funFact: 'Пчелните саќиња се составени од шестоаголници.',
    ),

    ColorShapeModel(
      id: 'diamond',
      name: 'Ромб',
      imagePath: 'assets/images/shapes/diamond.png',
      emoji: '🔷',
      displayColor: Color(0xFF74B9FF),
      type: ItemType.shape,
      audioPath: 'assets/audio/shapes/diamond.mp3',
      description: '4 еднакви страни, ротиран квадрат',
      funFact: 'Ромбот личи на навален квадрат.',
    ),
  ];

  static List<ColorShapeModel> get all => [...colors, ...shapes];
}