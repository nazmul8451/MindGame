import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import 'dart:math';

// Events
abstract class SpeedTapEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SpeedTapStarted extends SpeedTapEvent {}

class SpeedTapCircleTapped extends SpeedTapEvent {
  final double x;
  final double y;
  SpeedTapCircleTapped(this.x, this.y);
  @override
  List<Object?> get props => [x, y];
}

class SpeedTapTimerTicked extends SpeedTapEvent {
  final int seconds;
  SpeedTapTimerTicked(this.seconds);
  @override
  List<Object?> get props => [seconds];
}

// States
class SpeedTapState extends Equatable {
  final int score;
  final int timeRemaining;
  final double targetX;
  final double targetY;
  final bool isGameOver;

  const SpeedTapState({
    this.score = 0,
    this.timeRemaining = 10,
    this.targetX = 0.5,
    this.targetY = 0.5,
    this.isGameOver = false,
  });

  @override
  List<Object?> get props => [
    score,
    timeRemaining,
    targetX,
    targetY,
    isGameOver,
  ];

  SpeedTapState copyWith({
    int? score,
    int? timeRemaining,
    double? targetX,
    double? targetY,
    bool? isGameOver,
  }) {
    return SpeedTapState(
      score: score ?? this.score,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      targetX: targetX ?? this.targetX,
      targetY: targetY ?? this.targetY,
      isGameOver: isGameOver ?? this.isGameOver,
    );
  }
}

// Bloc
class SpeedTapBloc extends Bloc<SpeedTapEvent, SpeedTapState> {
  Timer? _timer;
  final Random _random = Random();

  SpeedTapBloc() : super(const SpeedTapState()) {
    on<SpeedTapStarted>(_onStarted);
    on<SpeedTapCircleTapped>(_onTapped);
    on<SpeedTapTimerTicked>(_onTimerTicked);
  }

  void _onStarted(SpeedTapStarted event, Emitter<SpeedTapState> emit) {
    _timer?.cancel();
    emit(
      SpeedTapState(
        targetX: _random.nextDouble(),
        targetY: _random.nextDouble(),
      ),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeRemaining > 0) {
        add(SpeedTapTimerTicked(state.timeRemaining - 1));
      } else {
        timer.cancel();
      }
    });
  }

  void _onTimerTicked(SpeedTapTimerTicked event, Emitter<SpeedTapState> emit) {
    if (event.seconds == 0) {
      emit(state.copyWith(timeRemaining: 0, isGameOver: true));
    } else {
      emit(state.copyWith(timeRemaining: event.seconds));
    }
  }

  void _onTapped(SpeedTapCircleTapped event, Emitter<SpeedTapState> emit) {
    if (state.isGameOver) return;

    emit(
      state.copyWith(
        score: state.score + 1,
        targetX: _random.nextDouble() * 0.8 + 0.1, // Keep away from edges
        targetY: _random.nextDouble() * 0.8 + 0.1,
      ),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
