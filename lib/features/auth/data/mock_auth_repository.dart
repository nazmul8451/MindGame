import 'dart:async';
import '../domain/auth_repository.dart';
import '../domain/user_entity.dart';

class MockAuthRepository implements AuthRepository {
  final _controller = StreamController<UserEntity?>();
  UserEntity? _currentUser;

  MockAuthRepository() {
    // Start as unauthenticated
    _controller.add(null);
  }

  @override
  Stream<UserEntity?> get user => _controller.stream;

  @override
  Future<UserEntity?> signInAnonymously() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = const UserEntity(
      id: 'mock_guest_id',
      email: 'guest@mindarena.demo',
      displayName: 'Guest Player',
      photoUrl: '',
      points: 100,
      rank: 'Bronze',
    );
    _controller.add(_currentUser);
    return _currentUser;
  }

  @override
  Future<UserEntity?> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _currentUser = const UserEntity(
      id: 'mock_google_id',
      email: 'user@google.demo',
      displayName: 'Premium Player',
      photoUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Felix',
      points: 500,
      rank: 'Gold',
    );
    _controller.add(_currentUser);
    return _currentUser;
  }

  @override
  Future<UserEntity?> signInWithApple() async {
    return signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _controller.add(null);
  }

  void dispose() {
    _controller.close();
  }
}
