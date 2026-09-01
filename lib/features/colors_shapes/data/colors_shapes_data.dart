import 'package:flutter/material.dart';
import '../models/color_shape_model.dart';

class ColorsShapesData {
  static const List<ColorShapeModel> colors = [
    ColorShapeModel(id: 'red',    name: 'Црвена',       imagePath: '', emoji: '🔴', displayColor: Color(0xFFFF4757), type: ItemType.color, audioPath: 'audio/colors/red.mp3',    description: 'Боја на јаболко и јагода',   funFact: 'Цrvената боја ја гледаме први кога се раѓаме!'),
    ColorShapeModel(id: 'blue',   name: 'Сина',         imagePath: '', emoji: '🔵', displayColor: Color(0xFF1E90FF), type: ItemType.color, audioPath: 'audio/colors/blue.mp3',   description: 'Боја на небото и морето',    funFact: 'Сината боја ги смирува луѓето!'),
    ColorShapeModel(id: 'green',  name: 'Зелена',       imagePath: '', emoji: '🟢', displayColor: Color(0xFF2ED573), type: ItemType.color, audioPath: 'audio/colors/green.mp3',  description: 'Боја на трева и лисја',      funFact: 'Зелената боја е најпријатна за очите!'),
    ColorShapeModel(id: 'yellow', name: 'Жолта',        imagePath: '', emoji: '🟡', displayColor: Color(0xFFFFD700), type: ItemType.color, audioPath: 'audio/colors/yellow.mp3', description: 'Боја на сонцето и банана',   funFact: 'Жолтата боја ја прави храната повкусна!'),
    ColorShapeModel(id: 'orange', name: 'Портокалова',  imagePath: '', emoji: '🟠', displayColor: Color.fromARGB(255, 255, 116, 3), type: ItemType.color, audioPath: 'audio/colors/orange.mp3', description: 'Боја на портокал',           funFact: 'Портокаловата боја го зголемува апетитот!'),
    ColorShapeModel(id: 'purple', name: 'Виолетова',    imagePath: '', emoji: '🟣', displayColor: Color(0xFF7B68EE), type: ItemType.color, audioPath: 'audio/colors/purple.mp3', description: 'Боја на грозје и лаванда',  funFact: 'Некогаш само кралевите носеле виолетово!'),
    ColorShapeModel(id: 'pink',   name: 'Розова',       imagePath: '', emoji: '🌸', displayColor: Color(0xFFFF6EB4), type: ItemType.color, audioPath: 'audio/colors/pink.mp3',   description: 'Боја на цвеќиња',           funFact: 'Розовата е мешавина на црвена и бела!'),
    ColorShapeModel(id: 'brown',  name: 'Кафена',       imagePath: '', emoji: '🟫', displayColor: Color(0xFF8B4513), type: ItemType.color, audioPath: 'audio/colors/brown.mp3',  description: 'Боја на земја и дрво',      funFact: 'Кафената боја е бојата на чоколадото!'),
    ColorShapeModel(id: 'black',  name: 'Црна',         imagePath: '', emoji: '⬛', displayColor: Color(0xFF2D3436), type: ItemType.color, audioPath: 'audio/colors/black.mp3',  description: 'Темна боја, боја на ноќ',   funFact: 'Црната боја ги апсорбира сите бои!'),
    ColorShapeModel(id: 'white',  name: 'Бела',         imagePath: '', emoji: '⬜', displayColor: Color(0xFFEEEEEE), type: ItemType.color, audioPath: 'audio/colors/white.mp3',  description: 'Боја на снег и облаци',     funFact: 'Белата боја ги содржи сите бои на виножитото!'),
  ];

  static const List<ColorShapeModel> shapes = [
    ColorShapeModel(id: 'circle',    name: 'Круг',         imagePath: 'assets/images/shapes/circle.png',    emoji: '⭕', displayColor: Color(0xFF1E90FF), type: ItemType.shape, audioPath: 'audio/colors/circle.mp3',    description: 'Тркалезна форма без агли',         funFact: 'Тркалото е круг - без него нема коли!'),
    ColorShapeModel(id: 'square',    name: 'Квадрат',      imagePath: 'assets/images/shapes/square.png',    emoji: '🟥', displayColor: Color(0xFFFF4757), type: ItemType.shape, audioPath: 'audio/colors/square.mp3',    description: '4 еднакви страни и 4 агли',         funFact: 'Скоро сите прозорци се квадрати!'),
    ColorShapeModel(id: 'triangle',  name: 'Триаголник',   imagePath: 'assets/images/shapes/triangle.png',  emoji: '🔺', displayColor: Color(0xFFFF9F43), type: ItemType.shape, audioPath: 'audio/colors/triangle.mp3',  description: '3 страни и 3 агли',                 funFact: 'Пирамидите во Египет се триаголници!'),
    ColorShapeModel(id: 'rectangle', name: 'Правоаголник', imagePath: 'assets/images/shapes/rectangle.png', emoji: '🟦', displayColor: Color(0xFF6C5CE7), type: ItemType.shape, audioPath: 'audio/colors/rectangle.mp3', description: '4 страни, 2 долги и 2 кратки',      funFact: 'Вратата на твојата соба е правоаголник!'),
    ColorShapeModel(id: 'star',      name: 'Ѕвезда',       imagePath: 'assets/images/shapes/star.png',      emoji: '⭐', displayColor: Color(0xFFFFD700), type: ItemType.shape, audioPath: 'audio/colors/star.mp3',      description: '5 краци, симбол на светло',         funFact: 'На небото има повеќе ѕвезди отколку зрна песок!'),
    ColorShapeModel(id: 'heart',     name: 'Срце',         imagePath: 'assets/images/shapes/heart.png',     emoji: '❤️', displayColor: Color(0xFFFF4757), type: ItemType.shape, audioPath: 'audio/colors/heart.mp3',     description: 'Симбол на љубов',                   funFact: 'Срцето чука 100.000 пати на ден!'),
    ColorShapeModel(id: 'diamond',   name: 'Ромб',         imagePath: 'assets/images/shapes/diamond.png',   emoji: '🔷', displayColor: Color(0xFF74B9FF), type: ItemType.shape, audioPath: 'audio/colors/diamond.mp3',   description: '4 еднакви страни, ротиран квадрат', funFact: 'Дијамантите имаат ромбоидна кристална структура!'),
    ColorShapeModel(id: 'oval',      name: 'Овал',         imagePath: 'assets/images/shapes/oval.png',      emoji: '🥚', displayColor: Color(0xFF00B894), type: ItemType.shape, audioPath: 'audio/colors/oval.mp3',      description: 'Издолжен круг',                     funFact: 'Јајцето е совршен овал!'),
  ];

  static List<ColorShapeModel> get all => [...colors, ...shapes];
}
