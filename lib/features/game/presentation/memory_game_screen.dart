import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'memory_game_bloc.dart';
import '../../../core/theme/app_colors.dart';

class MemoryGameScreen extends StatelessWidget {
  const MemoryGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MemoryGameBloc()..add(MemoryGameStarted()),
      child: const _MemoryGameView(),
    );
  }
}

class _MemoryGameView extends StatelessWidget {
  const _MemoryGameView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F172A), AppColors.background],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              const SizedBox(height: 20),
              _buildOpponentInfo(context),
              const Expanded(child: _CardGrid()),
              _buildPlayerInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return BlocBuilder<MemoryGameBloc, MemoryGameState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white70),
              ),
              GlassmorphicContainer(
                width: 100,
                height: 40,
                borderRadius: 20,
                blur: 10,
                alignment: Alignment.center,
                border: 1,
                linearGradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                borderGradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                child: Text(
                  '${state.timeRemaining}s',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 48), // Spacer to balance close button
            ],
          ),
        );
      },
    );
  }

  Widget _buildOpponentInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 15,
            backgroundColor: AppColors.secondary,
            child: Icon(Icons.person, size: 15, color: Colors.white),
          ),
          const SizedBox(width: 8),
          const Text('Opponent: John', style: TextStyle(color: Colors.white70)),
          const Spacer(),
          const Text(
            'Score: 2',
            style: TextStyle(
              color: AppColors.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerInfo(BuildContext context) {
    return BlocBuilder<MemoryGameBloc, MemoryGameState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.5),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Level 12',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '${state.score}',
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CardGrid extends StatelessWidget {
  const _CardGrid();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemoryGameBloc, MemoryGameState>(
      builder: (context, state) {
        if (state.isGameOver) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '🏆 Battle Finished!',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Final Score: ${state.score}',
                  style: const TextStyle(fontSize: 20, color: AppColors.accent),
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
          padding: const EdgeInsets.all(20),
          itemCount: state.cards.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final card = state.cards[index];
            return GestureDetector(
              onTap: () =>
                  context.read<MemoryGameBloc>().add(MemoryCardTapped(index)),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return RotationYTransition(
                    animation: animation,
                    child: child,
                  );
                },
                child: card.isFlipped || card.isMatched
                    ? _CardFront(card: card, key: ValueKey('front_$index'))
                    : _CardBack(key: ValueKey('back_$index')),
              ),
            );
          },
        );
      },
    );
  }
}

class _CardFront extends StatelessWidget {
  final dynamic card;
  const _CardFront({required this.card, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: card.isMatched
            ? AppColors.success.withOpacity(0.3)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: card.isMatched ? AppColors.success : AppColors.primary,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(card.content, style: const TextStyle(fontSize: 32)),
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  const _CardBack({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: double.infinity,
      borderRadius: 12,
      blur: 10,
      alignment: Alignment.center,
      border: 1,
      linearGradient: LinearGradient(
        colors: [
          AppColors.primary.withOpacity(0.2),
          AppColors.primary.withOpacity(0.1),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.05)],
      ),
      child: const Icon(Icons.help_outline, color: Colors.white30, size: 30),
    );
  }
}

class RotationYTransition extends AnimatedWidget {
  const RotationYTransition({
    super.key,
    required Animation<double> animation,
    this.child,
  }) : super(listenable: animation);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    final rotationValue = (1 - animation.value) * 3.141592;
    return Transform(
      transform: Matrix4.rotationY(rotationValue),
      alignment: Alignment.center,
      child: rotationValue > (3.141592 / 2) ? const SizedBox() : child,
    );
  }
}
