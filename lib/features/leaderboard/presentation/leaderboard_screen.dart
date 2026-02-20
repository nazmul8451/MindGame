import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Leaderboard'),
        backgroundColor: AppColors.background,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), AppColors.background],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Text(
                '#${index + 1}',
                style: const TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              title: Text(
                'Player ${index + 1}',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                '${10000 - index * 500} pts',
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: const Icon(Icons.emoji_events, color: AppColors.gold),
            );
          },
        ),
      ),
    );
  }
}
