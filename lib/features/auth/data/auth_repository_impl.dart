import 'package:firebase_auth/firebase_auth.dart';
import '../domain/auth_repository.dart';
import '../domain/user_entity.dart';
import 'user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<UserEntity?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) return null;
      return UserModel.fromFirebaseUser(firebaseUser);
    });
  }

  @override
  Future<UserEntity?> signInAnonymously() async {
    try {
      final credential = await _firebaseAuth.signInAnonymously();
      if (credential.user == null) return null;
      return UserModel.fromFirebaseUser(credential.user!);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserEntity?> signInWithGoogle() async {
    // TODO: Implement real Google Sign In
    return signInAnonymously();
  }

  @override
  Future<UserEntity?> signInWithApple() async {
    // TODO: Implement real Apple Sign In
    return signInAnonymously();
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
