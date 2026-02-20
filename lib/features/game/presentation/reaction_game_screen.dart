import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'reaction_bloc.dart';
import '../../../core/theme/app_colors.dart';

class ReactionGameScreen extends StatelessWidget {
  const ReactionGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReactionBloc()..add(ReactionStarted()),
      child: const _ReactionGameView(),
    );
  }
}

class _ReactionGameView extends StatelessWidget {
  const _ReactionGameView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReactionBloc, ReactionState>(
      builder: (context, state) {
        Color bgColor;
        String message;
        IconData icon;

        switch (state.status) {
          case ReactionStatus.waiting:
            bgColor = AppColors.background;
            message = 'WAIT FOR GREEN...';
            icon = Icons.hourglass_empty;
            break;
          case ReactionStatus.ready:
            bgColor = AppColors.success;
            message = 'TAP NOW!';
            icon = Icons.touch_app;
            break;
          case ReactionStatus.tooEarly:
            bgColor = AppColors.error;
            message = 'TOO EARLY! TAP TO RETRY';
            icon = Icons.warning;
            break;
          case ReactionStatus.tapped:
            bgColor = AppColors.accent;
            message = '${state.reactionTime?.inMilliseconds}ms';
            icon = Icons.timer;
            break;
        }

        return GestureDetector(
          onTap: () {
            if (state.status == ReactionStatus.tapped ||
                state.status == ReactionStatus.tooEarly) {
              context.read<ReactionBloc>().add(ReactionStarted());
            } else {
              context.read<ReactionBloc>().add(ReactionTapped());
            }
          },
          child: Scaffold(
            backgroundColor: bgColor,
            body: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 20,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white70),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, size: 100, color: Colors.white),
                        const SizedBox(height: 24),
                        Text(
                          message,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (state.status == ReactionStatus.tapped) ...[
                          const SizedBox(height: 20),
                          Text(
                            'Best: ${state.bestTimeMs}ms',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            'Tap to play again',
                            style: TextStyle(color: Colors.white54),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
