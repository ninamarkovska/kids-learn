import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../data/colors_shapes_data.dart';
import '../models/color_shape_model.dart';
import '../widgets/color_shape_card.dart';
import '../../../core/accessibility/accessibility_settings.dart';
import '../../../core/widgets/page_scaffold.dart';
import '../../../core/services/vibration_service.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';

class ColorsShapesScreen extends StatefulWidget {
  const ColorsShapesScreen({super.key});

  @override
  State<ColorsShapesScreen> createState() => _ColorsShapesScreenState();
}

class _ColorsShapesScreenState extends State<ColorsShapesScreen> {
  String _tab = 'colors';

  final _vib = VibrationService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  ColorShapeModel? _selected;

  List<ColorShapeModel> get _items =>
      _tab == 'colors'
          ? ColorsShapesData.colors
          : ColorsShapesData.shapes;

  Future<void> _onTap(ColorShapeModel item) async {
    setState(() => _selected = item);
    _vib.success();

    if (item.audioPath.isEmpty) return;

    try {
      final asset = item.audioPath.replaceFirst('assets/', '');

      debugPrint('Playing asset: $asset');

      await _audioPlayer.stop();
      await _audioPlayer.setSourceAsset(asset);
      await _audioPlayer.resume();
    } catch (e) {
      debugPrint('AUDIO ERROR: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AccessibilityScope.of(context).palette;

    return PageScaffold(
      title: '🎨 Бои и Форми',
      gradientColors: palette.colorsShapesGradient.colors,
      child: Column(
        children: [
          _buildTabs(),
          if (_selected != null) _buildSelectedBanner(),
          Expanded(child: _buildGrid()),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final palette = AccessibilityScope.of(context).palette;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: palette.controlBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: palette.border,
          width: palette.borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: palette.border.withOpacity(0.12),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          _tabBtn('colors', '🎨 Бои'),
          _tabBtn('shapes', '🔷 Форми'),
        ],
      ),
    );
  }

  Widget _tabBtn(String key, String label) {
    final active = _tab == key;
    final palette = AccessibilityScope.of(context).palette;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _tab = key;
            _selected = null;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? palette.selected : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: active
                ? Border.all(
              color: palette.border,
              width: palette.borderWidth,
            )
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppTypeScale.interactive,
              fontWeight: FontWeight.w700,
              color: active ? palette.onCard : palette.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedBanner() {
    final item = _selected!;
    final palette = AccessibilityScope.of(context).palette;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: palette.selectedBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: palette.selected,
          width: palette.borderWidth + 1,
        ),
      ),
      child: Row(
        children: [
          if (item.type == ItemType.color)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: item.displayColor,
                shape: BoxShape.circle,
              ),
            )
          else
            Text(item.emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: AppTypeScale.itemTitle,
                    fontWeight: FontWeight.w800,
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: AppTypeScale.secondary,
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.volume_up_rounded, color: palette.selected),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          padding: const EdgeInsets.all(AppDimensions.learningGridPadding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: AppDimensions.responsiveColumnCount(
              availableWidth: constraints.maxWidth,
              minimumCardWidth: AppDimensions.learningCardMinWidth,
            ),
            crossAxisSpacing: AppDimensions.learningGridSpacing,
            mainAxisSpacing: AppDimensions.learningGridSpacing,
            childAspectRatio: 0.88,
          ),
          itemCount: _items.length,
          itemBuilder: (_, i) {
            final item = _items[i];

            return ColorShapeCard(
              item: item,
              selected: _selected == item,
              onTap: () => _onTap(item),
            );
          },
        );
      },
    );
  }
}