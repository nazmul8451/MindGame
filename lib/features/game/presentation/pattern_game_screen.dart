import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'pattern_game_bloc.dart';
import '../../../core/theme/app_colors.dart';

class PatternGameScreen extends StatelessWidget {
  const PatternGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PatternGameBloc()..add(PatternGameStarted()),
      child: const _PatternGameView(),
    );
  }
}

class _PatternGameView extends StatelessWidget {
  const _PatternGameView();

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
              _buildTopBar(context),
              const Expanded(child: _PatternGrid()),
              _buildBottomInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return BlocBuilder<PatternGameBloc, PatternGameState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white70),
              ),
              Text(
                'LEVEL ${state.level}',
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomInfo(BuildContext context) {
    return BlocBuilder<PatternGameBloc, PatternGameState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.surface.withOpacity(0.5)),
          child: Text(
            state.isShowingSequence
                ? 'Watch Carefully...'
                : 'Repeat the Pattern!',
            style: TextStyle(
              color: state.isShowingSequence
                  ? AppColors.warning
                  : AppColors.success,
              fontSize: 18,
            ),
          ),
        );
      },
    );
  }
}

class _PatternGrid extends StatelessWidget {
  const _PatternGrid();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatternGameBloc, PatternGameState>(
      builder: (context, state) {
        if (state.isGameOver) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Game Over!',
                  style: TextStyle(
                    fontSize: 32,
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Reached Level ${state.level}',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(40),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemBuilder: (context, index) {
            final isHighlighted =
                state.highlightingIndex != -1 &&
                state.sequence[state.highlightingIndex] == index;
            return GestureDetector(
              onTap: () =>
                  context.read<PatternGameBloc>().add(PatternTileTapped(index)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isHighlighted ? AppColors.accent : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isHighlighted
                      ? [
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.6),
                            blurRadius: 20,
                          ),
                        ]
                      : [],
                  border: Border.all(color: Colors.white12),
                ),
                child: Center(
                  child: isHighlighted
                      ? const Icon(Icons.star, color: Colors.white)
                      : null,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
