import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'injection_container.dart' as di;
import 'features/auth/presentation/auth_bloc.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/home/presentation/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isFirebaseAvailable = false;
  try {
    // Initializing Firebase (might fail if not configured)
    await Firebase.initializeApp();
    isFirebaseAvailable = true;
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  await di.init(isFirebaseAvailable: isFirebaseAvailable);

  runApp(const MindArenaApp());
}

class MindArenaApp extends StatelessWidget {
  const MindArenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<AuthBloc>(),
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.loading) {
          return const SplashScreen();
        }
        if (state.status == AuthStatus.authenticated) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      // Navigation is now handled by AuthWrapper, but if we want to force:
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthWrapper()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for logo animation
            const Icon(Icons.psychology, size: 100, color: Colors.white),
            const SizedBox(height: 24),
            Text(
              AppStrings.appName,
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ],
        ),
      ),
    );
  }
}
