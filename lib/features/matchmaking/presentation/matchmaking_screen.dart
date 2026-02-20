import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../game/presentation/memory_game_screen.dart';

class MatchmakingScreen extends StatefulWidget {
  const MatchmakingScreen({super.key});

  @override
  State<MatchmakingScreen> createState() => _MatchmakingScreenState();
}

class _MatchmakingScreenState extends State<MatchmakingScreen> {
  @override
  void initState() {
    super.initState();
    _startMatch();
  }

  _startMatch() async {
    await Future.delayed(const Duration(seconds: 4));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MemoryGameScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.background, AppColors.surface],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Finding Opponent...',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: AppColors.accent),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPlayerInfo('You', Icons.person),
                const Text(
                  'VS',
                  style: TextStyle(
                    fontSize: 32,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildPlayerInfo('Searching...', Icons.help_outline),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerInfo(String name, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.white.withOpacity(0.1),
          child: Icon(icon, size: 40, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Text(name, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
