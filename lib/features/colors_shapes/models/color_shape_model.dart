import 'package:flutter/material.dart';

enum ItemType { color, shape }

class ColorShapeModel {
  final String id;
  final String name;
  final String emoji;
  final Color displayColor;
  final ItemType type;
  final String audioPath;
  final String description;
  final String funFact;
   final String imagePath;

  const ColorShapeModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.displayColor,
    required this.type,
    required this.audioPath,
    required this.description,
    required this.funFact,
    required this.imagePath,
  });
}
