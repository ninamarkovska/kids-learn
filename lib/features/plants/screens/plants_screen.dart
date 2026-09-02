import 'package:flutter/material.dart';
import '../data/plants_data.dart';
import '../models/plant_model.dart';
import '../widgets/plant_card.dart';
import '../../../core/widgets/page_scaffold.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/vibration_service.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';
import '../../../core/accessibility/accessibility_settings.dart';

class PlantsScreen extends StatefulWidget {
  const PlantsScreen({super.key});
  @override
  State<PlantsScreen> createState() => _PlantsScreenState();
}

class _PlantsScreenState extends State<PlantsScreen> {
  String _selectedCategory = 'сите';
  PlantModel? _selected;
  final _tts = TtsService();
  final _audio = AudioService();
  final _vib = VibrationService();

  final _categories = ['сите', 'цвет', 'овошје', 'зеленчук', 'дрво', 'посебно'];

  List<PlantModel> get _filtered {
    if (_selectedCategory == 'сите') return PlantsData.plants;
    return PlantsData.plants
        .where((p) => p.category == _selectedCategory)
        .toList();
  }

  void _onTap(PlantModel plant) async {
    setState(() => _selected = plant);
    _vib.success();
    await _audio.playAsset(plant.audioPath);
    await _tts.speak(plant.name);
    await Future.delayed(const Duration(milliseconds: 600));
    await _tts.speak(plant.funFact);
  }

  @override
  Widget build(BuildContext context) {
    final palette = AccessibilityScope.of(context).palette;
    return PageScaffold(
      title: '🌿 Растенија',
      gradientColors: palette.plantsGradient.colors,
      child: Column(
        children: [
          _buildFilter(),
          if (_selected != null) _buildBanner(),
          Expanded(child: _buildGrid()),
        ],
      ),
    );
  }

  Widget _buildFilter() {
    final palette = AccessibilityScope.of(context).palette;
    return Container(
      height: 64,
      margin: const EdgeInsets.only(top: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (_, i) {
          final cat = _categories[i];
          final active = cat == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 14),
            child: GestureDetector(
              onTap: () => setState(() {
                _selectedCategory = cat;
                _selected = null;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: active ? palette.selected : palette.controlBackground,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: active ? palette.selected : palette.border,
                    width: active
                        ? palette.borderWidth + 1
                        : palette.borderWidth,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: palette.primary.withValues(alpha: 0.15),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Text(
                  _categoryLabel(cat),
                  style: TextStyle(
                    fontSize: AppTypeScale.interactive,
                    fontWeight: FontWeight.w700,
                    color: active ? palette.onCard : palette.textPrimary,
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
      case 'сите':
        return '🌍 Сите';
      case 'цвет':
        return '🌸 Цветови';
      case 'овошје':
        return '🍎 Овошје';
      case 'зеленчук':
        return '🥦 Зеленчук';
      case 'дрво':
        return '🌳 Дрвја';
      case 'посебно':
        return '🌵 Посебни';
      default:
        return cat;
    }
  }

  Widget _buildBanner() {
    final p = _selected!;
    final palette = AccessibilityScope.of(context).palette;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: palette.plantsGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.border, width: palette.borderWidth),
      ),
      child: Row(
        children: [
          Text(p.emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  style: TextStyle(
                    fontSize: AppTypeScale.itemTitle,
                    fontWeight: FontWeight.w800,
                    color: palette.onCard,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  p.funFact,
                  style: TextStyle(
                    fontSize: AppTypeScale.secondary,
                    color: palette.onCardSecondary,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
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
        itemCount: _filtered.length,
        itemBuilder: (_, i) => PlantCard(
          plant: _filtered[i],
          index: i,
          onTap: () => _onTap(_filtered[i]),
        ),
      ),
    );
  }
}
