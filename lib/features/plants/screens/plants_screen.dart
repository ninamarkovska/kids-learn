import 'package:flutter/material.dart';
import '../data/plants_data.dart';
import '../models/plant_model.dart';
import '../widgets/plant_card.dart';
import '../../../core/widgets/page_scaffold.dart';
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

  final _audio = AudioService();
  final _vib = VibrationService();

  bool _isBannerExpanded = false;
  bool _isMuted = false;

  final _categories = ['сите', 'овошје', 'зеленчук'];

  List<PlantModel> get _filtered {
    if (_selectedCategory == 'сите') return PlantsData.plants;
    return PlantsData.plants
        .where((p) => p.category == _selectedCategory)
        .toList();
  }

  Future<void> _onTap(PlantModel plant) async {
    setState(() {
      _selected = plant;
      _isBannerExpanded = false;
    });

    _vib.success();
    if (!_isMuted) {
      await _audio.playAsset(plant.audioPath);
    }
  }



  Future<void> _toggleMute() async {
    setState(() => _isMuted = !_isMuted);

    if (_isMuted) {
      await _audio.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = AccessibilityScope.of(context).palette;

    return PageScaffold(
      titleWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/plants/fruitsvegetables.png',
            height: 34,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),
          const Text(
            'Овошје и Зеленчук',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
      gradientColors: palette.plantsGradient.colors,
      child: Column(
        children: [
          _buildFilter(),

          // Banner е фиксен
          if (_selected != null) _buildBanner(),

          // Само ова се скрола
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
              onTap: () {
                setState(() {
                  _selectedCategory = cat;
                  _selected = null;
                  _isBannerExpanded = false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: active
                      ? palette.selected
                      : palette.controlBackground,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: active ? palette.selected : palette.border,
                    width: active
                        ? palette.borderWidth + 1
                        : palette.borderWidth,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: palette.primary.withOpacity(0.12),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Text(
                  _categoryLabel(cat),
                  style: TextStyle(
                    fontSize: AppTypeScale.interactive,
                    fontWeight: FontWeight.w700,
                    color: active
                        ? palette.onCard
                        : palette.textPrimary,
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
      case 'овошје':
        return '🍎 Овошје';
      case 'зеленчук':
        return '🥦 Зеленчук';
      default:
        return cat;
    }
  }

  Widget _buildBanner() {
    final plant = _selected!;
    final palette = AccessibilityScope.of(context).palette;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        gradient: palette.plantsGradient,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: palette.border,
          width: palette.borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: palette.primary.withOpacity(0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: _isBannerExpanded ? 80 : 64,
            height: _isBannerExpanded ? 80 : 64,
            padding: const EdgeInsets.only(left: 4),
            child: Image.asset(
              plant.imagePath,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Text(
                plant.emoji,
                style: TextStyle(
                  fontSize: _isBannerExpanded ? 70 : 50,
                ),
              ),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            plant.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: _isBannerExpanded ? 28 : 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 4),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              plant.funFact,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _isBannerExpanded ? 17 : 15,
                fontWeight: FontWeight.w600,
                height: 1.4,
                color: Colors.white.withOpacity(0.95),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isMuted ? null : () => _audio.playAsset(plant.audioPath),
                  icon: const Icon(Icons.volume_up_rounded),
                  label: const Text(
                    'Слушни',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: palette.primary,
                    disabledBackgroundColor: Colors.white70,
                    disabledForegroundColor: Colors.grey,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: _toggleMute,
                  icon: Icon(
                    _isMuted
                        ? Icons.notifications_off_rounded
                        : Icons.notifications_active_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _isBannerExpanded = !_isBannerExpanded;
                    });
                  },
                  icon: Icon(
                    _isBannerExpanded
                        ? Icons.zoom_out_rounded
                        : Icons.zoom_in_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final palette = AccessibilityScope.of(context).palette;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
          child: Row(
            children: [
              Icon(
                Icons.grid_view_rounded,
                color: palette.primary,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'Избери овошје или зеленчук',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: palette.textPrimary,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
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
                itemBuilder: (_, index) {
                  return PlantCard(
                    plant: _filtered[index],
                    index: index,
                    onTap: () => _onTap(_filtered[index]),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
