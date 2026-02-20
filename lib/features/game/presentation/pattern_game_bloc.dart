import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import 'dart:math';

// Events
abstract class PatternGameEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PatternGameStarted extends PatternGameEvent {}

class PatternTileTapped extends PatternGameEvent {
  final int index;
  PatternTileTapped(this.index);
  @override
  List<Object?> get props => [index];
}

class PatternSequenceShown extends PatternGameEvent {}

// States
class PatternGameState extends Equatable {
  final List<int> sequence;
  final List<int> userSequence;
  final int highlightingIndex; // Index in sequence currently showing
  final bool isShowingSequence;
  final int level;
  final bool isGameOver;

  const PatternGameState({
    this.sequence = const [],
    this.userSequence = const [],
    this.highlightingIndex = -1,
    this.isShowingSequence = false,
    this.level = 1,
    this.isGameOver = false,
  });

  @override
  List<Object?> get props => [
    sequence,
    userSequence,
    highlightingIndex,
    isShowingSequence,
    level,
    isGameOver,
  ];

  PatternGameState copyWith({
    List<int>? sequence,
    List<int>? userSequence,
    int? highlightingIndex,
    bool? isShowingSequence,
    int? level,
    bool? isGameOver,
  }) {
    return PatternGameState(
      sequence: sequence ?? this.sequence,
      userSequence: userSequence ?? this.userSequence,
      highlightingIndex: highlightingIndex ?? this.highlightingIndex,
      isShowingSequence: isShowingSequence ?? this.isShowingSequence,
      level: level ?? this.level,
      isGameOver: isGameOver ?? this.isGameOver,
    );
  }
}

// Bloc
class PatternGameBloc extends Bloc<PatternGameEvent, PatternGameState> {
  final Random _random = Random();

  PatternGameBloc() : super(const PatternGameState()) {
    on<PatternGameStarted>(_onStarted);
    on<PatternTileTapped>(_onTileTapped);
    on<PatternSequenceShown>(_onSequenceShown);
  }

  void _onStarted(PatternGameStarted event, Emitter<PatternGameState> emit) {
    _startNewLevel(emit, 1);
  }

  void _startNewLevel(Emitter<PatternGameState> emit, int level) async {
    final newSequence = List.generate(level + 2, (_) => _random.nextInt(9));
    emit(
      state.copyWith(
        sequence: newSequence,
        userSequence: [],
        level: level,
        isShowingSequence: true,
        highlightingIndex: -1,
      ),
    );

    // Show sequence one by one
    for (int i = 0; i < newSequence.length; i++) {
      await Future.delayed(const Duration(milliseconds: 600));
      emit(state.copyWith(highlightingIndex: i));
      await Future.delayed(const Duration(milliseconds: 300));
      emit(state.copyWith(highlightingIndex: -1));
    }

    add(PatternSequenceShown());
  }

  void _onSequenceShown(
    PatternSequenceShown event,
    Emitter<PatternGameState> emit,
  ) {
    emit(state.copyWith(isShowingSequence: false));
  }

  void _onTileTapped(PatternTileTapped event, Emitter<PatternGameState> emit) {
    if (state.isShowingSequence || state.isGameOver) return;

    final newUserSequence = List<int>.from(state.userSequence)
      ..add(event.index);

    // Check if input is correct
    final currentStep = newUserSequence.length - 1;
    if (newUserSequence[currentStep] != state.sequence[currentStep]) {
      emit(state.copyWith(isGameOver: true));
      return;
    }

    emit(state.copyWith(userSequence: newUserSequence));

    if (newUserSequence.length == state.sequence.length) {
      // Level complete!
      _startNewLevel(emit, state.level + 1);
    }
  }
}
