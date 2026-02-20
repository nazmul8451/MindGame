import 'package:equatable/equatable.dart';

class MemoryCard extends Equatable {
  final int id;
  final String content;
  final bool isFlipped;
  final bool isMatched;

  const MemoryCard({
    required this.id,
    required this.content,
    this.isFlipped = false,
    this.isMatched = false,
  });

  MemoryCard copyWith({bool? isFlipped, bool? isMatched}) {
    return MemoryCard(
      id: id,
      content: content,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }

  @override
  List<Object?> get props => [id, content, isFlipped, isMatched];
}
