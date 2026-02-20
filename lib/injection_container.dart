import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'features/auth/domain/auth_repository.dart';
import 'features/auth/data/auth_repository_impl.dart';
import 'features/auth/presentation/auth_bloc.dart';
import 'features/auth/data/mock_auth_repository.dart';

final sl = GetIt.instance;

Future<void> init({bool isFirebaseAvailable = true}) async {
  // Bloc
  sl.registerFactory(() => AuthBloc(authRepository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => isFirebaseAvailable
        ? AuthRepositoryImpl(firebaseAuth: sl())
        : MockAuthRepository(),
  );

  // External
  if (isFirebaseAvailable) {
    sl.registerLazySingleton(() => FirebaseAuth.instance);
  }
}
