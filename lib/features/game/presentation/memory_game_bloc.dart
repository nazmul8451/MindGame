import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/memory_card_model.dart';
import 'dart:async';

// Events
abstract class MemoryGameEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MemoryGameStarted extends MemoryGameEvent {}

class MemoryCardTapped extends MemoryGameEvent {
  final int index;
  MemoryCardTapped(this.index);
  @override
  List<Object?> get props => [index];
}

class MemoryGameTimerTicked extends MemoryGameEvent {
  final int seconds;
  MemoryGameTimerTicked(this.seconds);
  @override
  List<Object?> get props => [seconds];
}

// States
class MemoryGameState extends Equatable {
  final List<MemoryCard> cards;
  final List<int> flippedIndices;
  final int score;
  final int timeRemaining;
  final bool isGameOver;

  const MemoryGameState({
    this.cards = const [],
    this.flippedIndices = const [],
    this.score = 0,
    this.timeRemaining = 60,
    this.isGameOver = false,
  });

  @override
  List<Object?> get props => [
    cards,
    flippedIndices,
    score,
    timeRemaining,
    isGameOver,
  ];

  MemoryGameState copyWith({
    List<MemoryCard>? cards,
    List<int>? flippedIndices,
    int? score,
    int? timeRemaining,
    bool? isGameOver,
  }) {
    return MemoryGameState(
      cards: cards ?? this.cards,
      flippedIndices: flippedIndices ?? this.flippedIndices,
      score: score ?? this.score,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      isGameOver: isGameOver ?? this.isGameOver,
    );
  }
}

// Bloc
class MemoryGameBloc extends Bloc<MemoryGameEvent, MemoryGameState> {
  Timer? _timer;

  MemoryGameBloc() : super(const MemoryGameState()) {
    on<MemoryGameStarted>(_onGameStarted);
    on<MemoryCardTapped>(_onCardTapped);
    on<MemoryGameTimerTicked>(_onTimerTicked);
  }

  void _onGameStarted(MemoryGameStarted event, Emitter<MemoryGameState> emit) {
    _timer?.cancel();
    final items = ['🧠', '🔥', '⚡', '🌟', '💎', '🚀', '🎨', '🎮'];
    final gameItems = [...items, ...items]..shuffle();
    final cards = List.generate(
      gameItems.length,
      (i) => MemoryCard(id: i, content: gameItems[i]),
    );

    emit(MemoryGameState(cards: cards, timeRemaining: 60));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeRemaining > 0 && !state.isGameOver) {
        add(MemoryGameTimerTicked(state.timeRemaining - 1));
      } else {
        timer.cancel();
      }
    });
  }

  void _onTimerTicked(
    MemoryGameTimerTicked event,
    Emitter<MemoryGameState> emit,
  ) {
    if (event.seconds == 0) {
      emit(state.copyWith(timeRemaining: 0, isGameOver: true));
    } else {
      emit(state.copyWith(timeRemaining: event.seconds));
    }
  }

  Future<void> _onCardTapped(
    MemoryCardTapped event,
    Emitter<MemoryGameState> emit,
  ) async {
    if (state.flippedIndices.length >= 2 ||
        state.cards[event.index].isFlipped ||
        state.cards[event.index].isMatched ||
        state.isGameOver) {
      return;
    }

    final newCards = List<MemoryCard>.from(state.cards);
    newCards[event.index] = newCards[event.index].copyWith(isFlipped: true);

    final newFlipped = List<int>.from(state.flippedIndices)..add(event.index);

    emit(state.copyWith(cards: newCards, flippedIndices: newFlipped));

    if (newFlipped.length == 2) {
      final idx1 = newFlipped[0];
      final idx2 = newFlipped[1];

      if (state.cards[idx1].content == state.cards[idx2].content) {
        // Match!
        newCards[idx1] = newCards[idx1].copyWith(isMatched: true);
        newCards[idx2] = newCards[idx2].copyWith(isMatched: true);

        final allMatched = newCards.every((c) => c.isMatched);
        emit(
          state.copyWith(
            cards: newCards,
            flippedIndices: [],
            score: state.score + 10,
            isGameOver: allMatched,
          ),
        );
      } else {
        // No match
        await Future.delayed(const Duration(milliseconds: 500));
        newCards[idx1] = newCards[idx1].copyWith(isFlipped: false);
        newCards[idx2] = newCards[idx2].copyWith(isFlipped: false);
        emit(state.copyWith(cards: newCards, flippedIndices: []));
      }
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
