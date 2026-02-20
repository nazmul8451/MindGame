import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../domain/auth_repository.dart';
import '../domain/user_entity.dart';

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthUserChanged extends AuthEvent {
  final UserEntity? user;
  AuthUserChanged(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthSignInAnonymouslyRequested extends AuthEvent {}

class AuthSignOutRequested extends AuthEvent {}

// States
enum AuthStatus { authenticated, unauthenticated, loading }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;

  const AuthState({this.status = AuthStatus.loading, this.user});

  @override
  List<Object?> get props => [status, user];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthState()) {
    on<AuthUserChanged>((event, emit) {
      emit(
        AuthState(
          status: event.user != null
              ? AuthStatus.authenticated
              : AuthStatus.unauthenticated,
          user: event.user,
        ),
      );
    });

    on<AuthSignInAnonymouslyRequested>((event, emit) async {
      emit(const AuthState(status: AuthStatus.loading));
      await _authRepository.signInAnonymously();
    });

    on<AuthSignOutRequested>((event, emit) async {
      await _authRepository.signOut();
    });

    // Subscribe to user changes
    _authRepository.user.listen((user) {
      add(AuthUserChanged(user));
    });
  }
}
