import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String photoUrl;
  final int points;
  final String rank;

  const UserEntity({
    required this.id,
    required this.email,
    required this.displayName,
    required this.photoUrl,
    this.points = 0,
    this.rank = 'Bronze',
  });

  @override
  List<Object?> get props => [id, email, displayName, photoUrl, points, rank];
}
