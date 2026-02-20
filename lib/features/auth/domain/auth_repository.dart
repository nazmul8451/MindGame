import 'user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> signInAnonymously();
  Future<UserEntity?> signInWithGoogle();
  Future<UserEntity?> signInWithApple();
  Future<void> signOut();
  Stream<UserEntity?> get user;
}
