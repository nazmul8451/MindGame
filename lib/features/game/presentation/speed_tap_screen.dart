import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'speed_tap_bloc.dart';
import '../../../core/theme/app_colors.dart';

class SpeedTapScreen extends StatelessWidget {
  const SpeedTapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpeedTapBloc()..add(SpeedTapStarted()),
      child: const _SpeedTapView(),
    );
  }
}

class _SpeedTapView extends StatelessWidget {
  const _SpeedTapView();

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
              const Expanded(child: _TappingArea()),
              _buildBottomInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return BlocBuilder<SpeedTapBloc, SpeedTapState>(
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
                'TIME: ${state.timeRemaining}s',
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
    return BlocBuilder<SpeedTapBloc, SpeedTapState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.5),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'SCORE: ',
                style: TextStyle(color: Colors.white70, fontSize: 20),
              ),
              Text(
                '${state.score}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
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

class _TappingArea extends StatelessWidget {
  const _TappingArea();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpeedTapBloc, SpeedTapState>(
      builder: (context, state) {
        if (state.isGameOver) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Time\'s Up!',
                  style: TextStyle(
                    fontSize: 32,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'You tapped ${state.score} times!',
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 100),
                  left: state.targetX * (constraints.maxWidth - 80),
                  top: state.targetY * (constraints.maxHeight - 80),
                  child: GestureDetector(
                    onTapUp: (_) => context.read<SpeedTapBloc>().add(
                      SpeedTapCircleTapped(state.targetX, state.targetY),
                    ),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [AppColors.accent, AppColors.primary],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.touch_app,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
