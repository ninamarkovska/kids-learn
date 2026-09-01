import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/services/vibration_service.dart';
import '../animals/screens/animals_screen.dart';
import '../colors_shapes/screens/colors_shapes_screen.dart';
import '../alphabet/screens/alphabet_screen.dart';
import '../plants/screens/plants_screen.dart';
import '../quiz/screens/quiz_screen.dart';

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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.homeGradient),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxHeight < 700;
              final width = constraints.maxWidth;
              final titleFontSize = (width * 0.082).clamp(30.0, 34.0);

              return Column(
                children: [
                  SizedBox(height: compact ? 12 : 20),
                  _buildTitle(compact: compact, titleFontSize: titleFontSize),
                  SizedBox(height: compact ? 14 : 22),
                  Expanded(child: _buildTopicList()),
                  SizedBox(height: compact ? 12 : 16),
                  _buildQuizButton(compact: compact),
                  SizedBox(height: compact ? 10 : 12),
                  _buildFooter(),
                  SizedBox(height: compact ? 12 : 16),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTitle({required bool compact, required double titleFontSize}) {
    return ScaleTransition(
      scale: _titleAnim,
      child: Column(
        children: [
          Container(
            width: compact ? 72 : 92,
            height: compact ? 72 : 92,
            decoration: BoxDecoration(
              gradient: AppColors.quizGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.quizColor.withOpacity(0.35),
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
              color: AppColors.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Избери тема за учење',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicList() {
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
            gradient: AppColors.animalsGradient,
            onTap: () => _navigate(const AnimalsScreen()),
          ),
          const SizedBox(height: 16),
          _buildMenuCard(
            title: 'Бои и Форми',
            subtitle: 'Учи бои!',
            emoji: '🎨',
            gradient: AppColors.colorsGradient,
            onTap: () => _navigate(const ColorsShapesScreen()),
          ),
          const SizedBox(height: 16),
          _buildMenuCard(
            title: 'Азбука',
            subtitle: 'Научи букви!',
            emoji: '🔤',
            gradient: AppColors.alphabetGradient,
            onTap: () => _navigate(const AlphabetScreen()),
          ),
          const SizedBox(height: 16),
          _buildMenuCard(
            title: 'Растенија',
            subtitle: 'Запознај ги!',
            emoji: '🌿',
            gradient: const LinearGradient(
              colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onTap: () => _navigate(const PlantsScreen()),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizButton({required bool compact}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: GestureDetector(
        onTap: () => _navigate(const QuizScreen()),
        child: Container(
          width: double.infinity,
          height: compact ? 68 : 74,
          decoration: BoxDecoration(
            gradient: AppColors.quizGradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.quizColor.withOpacity(0.4),
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
                child: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🧠', style: TextStyle(fontSize: 30)),
                      SizedBox(width: 12),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Квиз',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Тестирај ги знаењата!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
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
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withOpacity(0.4),
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
                        color: Colors.white.withOpacity(0.2),
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
                            style: const TextStyle(
                              fontSize: 23,
                              height: 1.1,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
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

  Widget _buildFooter() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        '🌟 Учи, Играј, Расти! 🌟',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
