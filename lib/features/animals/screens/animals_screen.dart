import 'package:flutter/material.dart';
import '../data/animals_data.dart';
import '../models/animal_model.dart';
import '../widgets/animal_card.dart';
import 'animal_detail_screen.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/page_scaffold.dart';

class AnimalsScreen extends StatefulWidget {
  const AnimalsScreen({super.key});

  @override
  State<AnimalsScreen> createState() => _AnimalsScreenState();
}

class _AnimalsScreenState extends State<AnimalsScreen> {
  String _selectedCategory = 'сите';

  final _categories = ['сите', 'домашно', 'дивјо', 'птица', 'море'];

  List<AnimalModel> get _filteredAnimals {
    if (_selectedCategory == 'сите') return AnimalsData.animals;
    return AnimalsData.animals
        .where((a) => a.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: '🐾 Животни',
      gradientColors: AppColors.animalsGradient.colors,
      child: Column(
        children: [
          // Категории
          _buildCategoryFilter(),
          // Грид
          Expanded(
            child: _buildAnimalsGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(top: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = cat == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.animalsColor : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.animalsColor.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  _categoryLabel(cat),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.animalsColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _categoryLabel(String cat) {
    switch (cat) {
      case 'сите': return '🌍 Сите';
      case 'домашно': return '🏠 Домашни';
      case 'дивјо': return '🌿 Дивји';
      case 'птица': return '🐦 Птици';
      case 'море': return '🌊 Море';
      default: return cat;
    }
  }

  Widget _buildAnimalsGrid() {
    final animals = _filteredAnimals;
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: animals.length,
      itemBuilder: (context, index) {
        final animal = animals[index];
        return AnimalCard(
          animal: animal,
          index: index,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AnimalDetailScreen(animal: animal),
              ),
            );
          },
        );
      },
    );
  }
}
