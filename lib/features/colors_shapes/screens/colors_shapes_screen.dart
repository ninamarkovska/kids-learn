import 'package:flutter/material.dart';
import '../data/colors_shapes_data.dart';
import '../models/color_shape_model.dart';
import '../widgets/color_shape_card.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/page_scaffold.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/services/vibration_service.dart';

class ColorsShapesScreen extends StatefulWidget {
  const ColorsShapesScreen({super.key});
  @override
  State<ColorsShapesScreen> createState() => _ColorsShapesScreenState();
}

class _ColorsShapesScreenState extends State<ColorsShapesScreen> {
  String _tab = 'colors';
  final _tts = TtsService();
  final _vib = VibrationService();
  ColorShapeModel? _selected;

  List<ColorShapeModel> get _items =>
      _tab == 'colors' ? ColorsShapesData.colors : ColorsShapesData.shapes;

  void _onTap(ColorShapeModel item) async {
    setState(() => _selected = item);
    _vib.success();
    if (item.type == ItemType.color) {
      await _tts.speakColor(item.name);
    } else {
      await _tts.speakShape(item.name);
    }
    await Future.delayed(const Duration(seconds: 1));
    await _tts.speak(item.funFact);
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: '🎨 Бои и Форми',
      gradientColors: AppColors.colorsGradient.colors,
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)]),
      child: Row(children: [
        _tabBtn('colors', '🎨 Бои'),
        _tabBtn('shapes', '🔷 Форми'),
      ]),
    );
  }

  Widget _tabBtn(String key, String label) {
    final active = _tab == key;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() { _tab = key; _selected = null; }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? AppColors.colorsShapesColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12)),
          child: Text(label, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
              color: active ? Colors.white : AppColors.textSecondary)),
        ),
      ),
    );
  }

  Widget _buildSelectedBanner() {
    final item = _selected!;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color.lerp(item.displayColor, Colors.white, 0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: item.displayColor.withOpacity(0.3), width: 2)),
      child: Row(children: [
        if (item.type == ItemType.color)
          Container(width: 36, height: 36,
            decoration: BoxDecoration(color: item.displayColor, shape: BoxShape.circle))
        else
          Text(item.emoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: item.displayColor)),
          Text(item.description, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ])),
        Icon(Icons.volume_up_rounded, color: item.displayColor),
      ]),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.9),
      itemCount: _items.length,
      itemBuilder: (_, i) => ColorShapeCard(item: _items[i], onTap: () => _onTap(_items[i])),
    );
  }
}
