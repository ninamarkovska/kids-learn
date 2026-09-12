import 'package:flutter/material.dart';
import '../../core/accessibility/accessibility_settings.dart';
import '../../core/accessibility/accessible_palette.dart';
import '../../core/services/vibration_service.dart';
import '../animals/screens/animals_screen.dart';
import '../colors_shapes/screens/colors_shapes_screen.dart';
import '../alphabet/screens/alphabet_screen.dart';
import '../plants/screens/plants_screen.dart';
import '../quiz/screens/quiz_screen.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _titleCtrl;
  late Animation<double> _titleAnim;
  final _vib = VibrationService();

  @override
  void initState() {
    super.initState();
    _titleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _titleAnim = CurvedAnimation(parent: _titleCtrl, curve: Curves.elasticOut);
    _titleCtrl.forward();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  void _navigate(Widget screen) {
    _vib.lightTap();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => screen,
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = AccessibilityScope.of(context).palette;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: palette.backgroundGradient,
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxHeight < 700;
              final width = constraints.maxWidth;
              final titleFontSize =
              (width * 0.082).clamp(30.0, 34.0);

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          'assets/images/logo_finki.png',
                          height: compact ? 32 : 36,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: compact ? 8 : 12),

                  _buildTitle(
                    compact: compact,
                    titleFontSize: titleFontSize,
                    palette: palette,
                  ),

                  SizedBox(height: compact ? 8 : 12),

                  _buildAccessibilityButton(palette),

                  SizedBox(height: compact ? 8 : 12),

                  Expanded(
                    child: _buildTopicList(palette),
                  ),

                  SizedBox(height: compact ? 12 : 16),

                  _buildQuizButton(
                    compact: compact,
                    palette: palette,
                  ),

                  SizedBox(height: compact ? 10 : 12),

                  _buildFooter(palette),

                  SizedBox(height: compact ? 12 : 16),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTitle({
    required bool compact,
    required double titleFontSize,
    required AccessiblePalette palette,
  }) {
    return ScaleTransition(
      scale: _titleAnim,
      child: Column(
        children: [
          Container(
            width: compact ? 72 : 92,
            height: compact ? 72 : 92,
            decoration: BoxDecoration(
              gradient: palette.quizGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: palette.primary.withValues(alpha: 0.35),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: Text('🎓', style: TextStyle(fontSize: 48)),
            ),
          ),
          SizedBox(height: compact ? 12 : 16),
          Text(
            'Учи со Забава!',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w900,
              color: palette.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Избери тема за учење',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessibilityButton(AccessiblePalette palette) {
    return Semantics(
      button: true,
      label: 'Пристапност. Отвори поставки за пристапност.',
      excludeSemantics: true,
      child: OutlinedButton.icon(
        onPressed: _showAccessibilitySettings,
        icon: const Icon(Icons.visibility_outlined),
        label: const Text('Пристапност'),
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.textPrimary,
          backgroundColor: palette.controlBackground,
          side: BorderSide(color: palette.border, width: palette.borderWidth),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  void _showAccessibilitySettings() {
    _vib.lightTap();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        final settings = AccessibilityScope.of(sheetContext);
        final palette = settings.palette;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Пристапност',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Режим на бои',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                for (final mode in ColorVisionMode.values)
                  _ColorModeOption(
                    mode: mode,
                    selected: settings.colorVisionMode == mode,
                    palette: palette,
                    onTap: () {
                      settings.setColorVisionMode(mode);
                      _vib.lightTap();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopicList(AccessiblePalette palette) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 2),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildMenuCard(
            title: 'Животни',
            subtitle: 'Запознај ги!',
            emoji: '🐾',
            gradient: palette.cardGradients[0],
            palette: palette,
            onTap: () => _navigate(const AnimalsScreen()),
          ),
          const SizedBox(height: 16),
          _buildMenuCard(
            title: 'Бои и Форми',
            subtitle: 'Учи бои!',
            emoji: '🎨',
            gradient: palette.cardGradients[1],
            palette: palette,
            onTap: () => _navigate(const ColorsShapesScreen()),
          ),
          const SizedBox(height: 16),
          _buildMenuCard(
            title: 'Азбука',
            subtitle: 'Научи букви!',
            emoji: '🔤',
            gradient: palette.cardGradients[2],
            palette: palette,
            onTap: () => _navigate(const AlphabetScreen()),
          ),
          const SizedBox(height: 16),
          _buildMenuCard(
            title: 'Овошје и зеленчук',
            subtitle: 'Запознај ги!',
            emoji: '🍓',
            gradient: palette.cardGradients[3],
            palette: palette,
            onTap: () => _navigate(const PlantsScreen()),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizButton({
    required bool compact,
    required AccessiblePalette palette,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: GestureDetector(
        onTap: () => _navigate(const QuizScreen()),
        child: Container(
          width: double.infinity,
          height: compact ? 68 : 74,
          decoration: BoxDecoration(
            gradient: palette.quizGradient,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: palette.border,
              width: palette.borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: palette.primary.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: 10,
                top: -5,
                child: Opacity(
                  opacity: 0.2,
                  child: const Text('🧠', style: TextStyle(fontSize: 80)),
                ),
              ),
              Positioned.fill(
                right: 46,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🧠', style: TextStyle(fontSize: 30)),
                      const SizedBox(width: 12),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Квиз',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: palette.onCard,
                            ),
                          ),
                          Text(
                            'Тестирај ги знаењата!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: palette.onCardSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required String title,
    required String subtitle,
    required String emoji,
    required LinearGradient gradient,
    required AccessiblePalette palette,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.85, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut,
        builder: (_, v, child) => Transform.scale(scale: v, child: child),
        child: Container(
          constraints: const BoxConstraints(minHeight: 112),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: palette.border,
              width: palette.borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: 4,
                bottom: -18,
                child: Opacity(
                  opacity: 0.25,
                  child: Text(emoji, style: const TextStyle(fontSize: 96)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 20,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(emoji, style: const TextStyle(fontSize: 42)),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 23,
                              height: 1.1,
                              fontWeight: FontWeight.w900,
                              color: palette.onCard,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: palette.onCardSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(AccessiblePalette palette) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        '🌟 Учи, Играј, Расти! 🌟',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: palette.textSecondary,
        ),
      ),
    );
  }
}

class _ColorModeOption extends StatelessWidget {
  const _ColorModeOption({
    required this.mode,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  final ColorVisionMode mode;
  final bool selected;
  final AccessiblePalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = selected ? 'избрано' : 'не е избрано';
    return Semantics(
      button: true,
      selected: selected,
      label: '${mode.label}, $status',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: selected
                  ? palette.selectedBackground
                  : palette.controlBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? palette.selected : palette.border,
                width: selected ? palette.borderWidth + 1 : palette.borderWidth,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  selected ? Icons.check_circle : Icons.circle_outlined,
                  color: selected ? palette.selected : palette.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    mode.label,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
                if (selected)
                  Text(
                    'Избрано',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: palette.selected,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
