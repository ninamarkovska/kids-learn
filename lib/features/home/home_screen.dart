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
    _titleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _titleAnim = CurvedAnimation(parent: _titleCtrl, curve: Curves.elasticOut);
    _titleCtrl.forward();
  }

  @override
  void dispose() { _titleCtrl.dispose(); super.dispose(); }

  void _navigate(Widget screen) {
    _vib.lightTap();
    Navigator.push(context, PageRouteBuilder(
      pageBuilder: (_, anim, __) => screen,
      transitionsBuilder: (_, anim, __, child) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
        child: child),
      transitionDuration: const Duration(milliseconds: 300),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.homeGradient),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildTitle(),
              const SizedBox(height: 24),
              Expanded(child: _buildGrid()),
              const SizedBox(height: 16),
              _buildQuizButton(),
              const SizedBox(height: 12),
              _buildFooter(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return ScaleTransition(
      scale: _titleAnim,
      child: Column(children: [
        Container(
          width: 100, height: 100,
          decoration: BoxDecoration(
            gradient: AppColors.quizGradient,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: AppColors.quizColor.withOpacity(0.35), blurRadius: 20, spreadRadius: 2)]),
          child: const Center(child: Text('🎓', style: TextStyle(fontSize: 52)))),
        const SizedBox(height: 16),
        const Text('Учи со Забава!',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900,
            color: AppColors.textPrimary, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        const Text('Избери тема за учење',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
      ]),
    );
  }

  Widget _buildGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildMenuCard(
            title: 'Животни', subtitle: 'Запознај ги!', emoji: '🐾',
            gradient: AppColors.animalsGradient,
            onTap: () => _navigate(const AnimalsScreen())),
          _buildMenuCard(
            title: 'Бои и Форми', subtitle: 'Учи бои!', emoji: '🎨',
            gradient: AppColors.colorsGradient,
            onTap: () => _navigate(const ColorsShapesScreen())),
          _buildMenuCard(
            title: 'Азбука', subtitle: 'Научи букви!', emoji: '🔤',
            gradient: AppColors.alphabetGradient,
            onTap: () => _navigate(const AlphabetScreen())),
          _buildMenuCard(
            title: 'Растенија', subtitle: 'Запознај ги!', emoji: '🌿',
            gradient: const LinearGradient(
              colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
            onTap: () => _navigate(const PlantsScreen())),
        ],
      ),
    );
  }

  Widget _buildQuizButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => _navigate(const QuizScreen()),
        child: Container(
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
            gradient: AppColors.quizGradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(
              color: AppColors.quizColor.withOpacity(0.4),
              blurRadius: 16, offset: const Offset(0, 6))]),
          child: Stack(children: [
            Positioned(right: 10, top: -5,
              child: Opacity(opacity: 0.2,
                child: const Text('🧠', style: TextStyle(fontSize: 80)))),
            const Center(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text('🧠', style: TextStyle(fontSize: 30)),
                SizedBox(width: 12),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Квиз', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                  Text('Тестирај ги знаењата!', style: TextStyle(fontSize: 12, color: Colors.white70)),
                ]),
              ]),
            ),
          ]),
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
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [BoxShadow(
              color: gradient.colors.first.withOpacity(0.4),
              blurRadius: 16, offset: const Offset(0, 6))]),
          child: Stack(
            children: [
              Positioned(right: -10, bottom: -10,
                child: Opacity(opacity: 0.25,
                  child: Text(emoji, style: const TextStyle(fontSize: 80)))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 40)),
                    const SizedBox(height: 8),
                    Text(title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                    Text(subtitle,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white70)),
                  ])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text('🌟 Учи, Играј, Расти! 🌟',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
    );
  }
}