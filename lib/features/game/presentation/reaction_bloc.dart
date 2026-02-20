import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import 'dart:math';

// Events
abstract class ReactionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReactionStarted extends ReactionEvent {}

class ReactionTapped extends ReactionEvent {}

class ReactionReadyTriggered extends ReactionEvent {}

// States
enum ReactionStatus { waiting, ready, tapped, tooEarly }

class ReactionState extends Equatable {
  final ReactionStatus status;
  final Duration? reactionTime;
  final int bestTimeMs;

  const ReactionState({
    this.status = ReactionStatus.waiting,
    this.reactionTime,
    this.bestTimeMs = 0,
  });

  @override
  List<Object?> get props => [status, reactionTime, bestTimeMs];

  ReactionState copyWith({
    ReactionStatus? status,
    Duration? reactionTime,
    int? bestTimeMs,
  }) {
    return ReactionState(
      status: status ?? this.status,
      reactionTime: reactionTime ?? this.reactionTime,
      bestTimeMs: bestTimeMs ?? this.bestTimeMs,
    );
  }
}

// Bloc
class ReactionBloc extends Bloc<ReactionEvent, ReactionState> {
  Timer? _timer;
  Stopwatch _stopwatch = Stopwatch();
  final Random _random = Random();

  ReactionBloc() : super(const ReactionState()) {
    on<ReactionStarted>(_onStarted);
    on<ReactionReadyTriggered>(_onReadyTriggered);
    on<ReactionTapped>(_onTapped);
  }

  void _onStarted(ReactionStarted event, Emitter<ReactionState> emit) {
    _timer?.cancel();
    _stopwatch.reset();
    emit(const ReactionState(status: ReactionStatus.waiting));

    final waitMs = 2000 + _random.nextInt(3000); // 2-5 seconds
    _timer = Timer(Duration(milliseconds: waitMs), () {
      add(ReactionReadyTriggered());
    });
  }

  void _onReadyTriggered(
    ReactionReadyTriggered event,
    Emitter<ReactionState> emit,
  ) {
    _stopwatch.start();
    emit(state.copyWith(status: ReactionStatus.ready));
  }

  void _onTapped(ReactionTapped event, Emitter<ReactionState> emit) {
    if (state.status == ReactionStatus.waiting) {
      _timer?.cancel();
      emit(state.copyWith(status: ReactionStatus.tooEarly));
    } else if (state.status == ReactionStatus.ready) {
      _stopwatch.stop();
      final time = _stopwatch.elapsed;
      final timeMs = time.inMilliseconds;
      final newBest = (state.bestTimeMs == 0 || timeMs < state.bestTimeMs)
          ? timeMs
          : state.bestTimeMs;
      emit(
        state.copyWith(
          status: ReactionStatus.tapped,
          reactionTime: time,
          bestTimeMs: newBest,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
