import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'memory_game_screen.dart';
import 'speed_tap_screen.dart';
import 'pattern_game_screen.dart';
import 'reaction_game_screen.dart';
import '../../../core/theme/app_colors.dart';

class GameSelectorScreen extends StatelessWidget {
  const GameSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), AppColors.background],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Text(
                      'Select Game Mode',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _GameModeCard(
                      title: 'Memory Battle',
                      description: 'Match the cards to win',
                      icon: Icons.grid_view_rounded,
                      color: AppColors.primary,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MemoryGameScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _GameModeCard(
                      title: 'Speed Tap',
                      description: 'Tap circles as fast as you can',
                      icon: Icons.touch_app,
                      color: AppColors.secondary,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SpeedTapScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _GameModeCard(
                      title: 'Pattern Memory',
                      description: 'Repeat the shown pattern',
                      icon: Icons.extension,
                      color: AppColors.accent,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PatternGameScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _GameModeCard(
                      title: 'Reaction Test',
                      description: 'Test your reflexes',
                      icon: Icons.timer,
                      color: AppColors.success,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReactionGameScreen(),
                        ),
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
}

class _GameModeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _GameModeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 120,
      borderRadius: 24,
      blur: 20,
      alignment: Alignment.center,
      border: 1,
      linearGradient: LinearGradient(
        colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
      ),
      borderGradient: LinearGradient(
        colors: [color.withOpacity(0.5), color.withOpacity(0.1)],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 30),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white24,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
