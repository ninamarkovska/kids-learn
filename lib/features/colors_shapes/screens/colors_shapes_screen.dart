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

  // ✅ Недостасуваше
  bool _isBannerExpanded = false;

  // ✅ Mute / Unmute
  bool _isMuted = false;

  List<ColorShapeModel> get _items =>
      _tab == 'colors'
          ? ColorsShapesData.colors
          : ColorsShapesData.shapes;

  Future<void> _playAudio(ColorShapeModel item) async {
    if (_isMuted || item.audioPath.isEmpty) return;

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

  Future<void> _onTap(ColorShapeModel item) async {
    setState(() => _selected = item);
    _vib.success();

    await _playAudio(item);
  }

  Future<void> _toggleMute() async {
    setState(() => _isMuted = !_isMuted);

    await _audioPlayer.setVolume(_isMuted ? 0 : 1);
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
            _isBannerExpanded = false;
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
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      padding: EdgeInsets.symmetric(
        horizontal: _isBannerExpanded ? 20 : 16,
        vertical: _isBannerExpanded ? 18 : 12,
      ),
      decoration: BoxDecoration(
        color: palette.selectedBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: palette.selected,
          width: palette.borderWidth + 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.type == ItemType.color)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _isBannerExpanded ? 64 : 48,
                  height: _isBannerExpanded ? 64 : 48,
                  decoration: BoxDecoration(
                    color: item.displayColor,
                    shape: BoxShape.circle,
                  ),
                )
              else if (item.id == 'triangle' ||
                  item.id == 'rectangle' ||
                  item.id == 'pentagon' ||
                  item.id == 'hexagon')
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _isBannerExpanded ? 64 : 48,
                  height: _isBannerExpanded ? 64 : 48,
                  child: Image.asset(
                    item.imagePath,
                    fit: BoxFit.contain,
                  ),
                )
              else
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: _isBannerExpanded ? 54 : 40,
                  ),
                  child: Text(item.emoji),
                ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: _isBannerExpanded ? 28 : 22,
                        fontWeight: FontWeight.w800,
                        color: palette.textPrimary,
                      ),
                      child: Text(item.name),
                    ),
                    const SizedBox(height: 4),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: _isBannerExpanded ? 18 : 15,
                        color: palette.textSecondary,
                        height: 1.35,
                      ),
                      child: Text(item.description),
                    ),
                  ],
                ),
              ),

              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: palette.selected.withOpacity(0.12),
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
                    color: palette.selected,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ✅ Големи копчиња
          Row(
            children: [
              if (item.audioPath.isNotEmpty)
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () => _playAudio(item),
                    icon: const Icon(Icons.volume_up_rounded, size: 28),
                    label: const Text(
                      'Слушни повторно',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      backgroundColor: palette.selected,
                      foregroundColor: palette.onCard,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),

              if (item.audioPath.isNotEmpty) const SizedBox(width: 10),

              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _isMuted ? Colors.red.shade400 : Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  onPressed: _toggleMute,
                  icon: Icon(
                    _isMuted
                        ? Icons.notifications_off_rounded
                        : Icons.notifications_active_rounded,
                    color: Colors.white,
                    size: 28,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.learningGridPadding,
            0,
            AppDimensions.learningGridPadding,
            AppDimensions.learningGridPadding,
          ),
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
