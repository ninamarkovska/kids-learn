import 'package:flutter/material.dart';
import '../data/animals_data.dart';
import '../models/animal_model.dart';
import '../widgets/animal_card.dart';
import 'animal_detail_screen.dart';
import '../../../core/accessibility/accessibility_settings.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';
import '../../../core/widgets/page_scaffold.dart';

class AnimalsScreen extends StatefulWidget {
  const AnimalsScreen({super.key});

  @override
  State<AnimalsScreen> createState() => _AnimalsScreenState();
}

class _AnimalsScreenState extends State<AnimalsScreen> {
  String _selectedCategory = 'сите';

  final _categories = ['сите', 'домашно', 'дивјо', 'птица', 'вода'];

  List<AnimalModel> get _filteredAnimals {
    if (_selectedCategory == 'сите') return AnimalsData.animals;
    return AnimalsData.animals
        .where((a) => a.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AccessibilityScope.of(context).palette;
    return PageScaffold(
      title: '🐾 Животни',
      gradientColors: palette.animalsGradient.colors,
      child: Column(
        children: [
          // Категории
          _buildCategoryFilter(),
          // Грид
          Expanded(child: _buildAnimalsGrid()),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final palette = AccessibilityScope.of(context).palette;
    return Container(
      height: 64,
      margin: const EdgeInsets.only(top: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = cat == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 14),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? palette.selected
                      : palette.controlBackground,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? palette.selected : palette.border,
                    width: isSelected
                        ? palette.borderWidth + 1
                        : palette.borderWidth,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: palette.primary.withValues(alpha: 0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _categoryEmoji(cat),
                      style: const TextStyle(fontSize: 21),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _categoryName(cat),
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: AppTypeScale.interactive,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? palette.onCard
                            : palette.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _categoryEmoji(String cat) {
    switch (cat) {
      case 'сите':
        return '🌍';
      case 'домашно':
        return '🏠';
      case 'дивјо':
        return '🌿';
      case 'птица':
        return '🐦';
      case 'вода':
        return '🌊';
      default:
        return '🐾';
    }
  }

  String _categoryName(String cat) {
    switch (cat) {
      case 'сите':
        return 'Сите';
      case 'домашно':
        return 'Домашни';
      case 'дивјо':
        return 'Дивји';
      case 'птица':
        return 'Птици';
      case 'вода':
        return 'Вода';
      default:
        return cat;
    }
  }

  Widget _buildAnimalsGrid() {
    final animals = _filteredAnimals;
    return LayoutBuilder(
      builder: (context, constraints) => GridView.builder(
        padding: const EdgeInsets.all(AppDimensions.learningGridPadding),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: AppDimensions.responsiveColumnCount(
            availableWidth: constraints.maxWidth,
            minimumCardWidth: AppDimensions.learningCardMinWidth,
          ),
          crossAxisSpacing: AppDimensions.learningGridSpacing,
          mainAxisSpacing: AppDimensions.learningGridSpacing,
          childAspectRatio: 0.82,
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
      ),
    );
  }
}
