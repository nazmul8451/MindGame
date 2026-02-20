import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'auth_bloc.dart';
import '../../../core/theme/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.background, AppColors.surface],
              ),
            ),
          ),
          // Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.psychology, size: 100, color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    'MindArena',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Real-Time Brain Battle',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 60),

                  // Login Options in a Glassmorphic container
                  GlassmorphicContainer(
                    width: double.infinity,
                    height: 350,
                    borderRadius: 24,
                    blur: 20,
                    alignment: Alignment.center,
                    border: 2,
                    linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                    borderGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.5),
                        Colors.white.withOpacity(0.2),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _LoginButton(
                            label: 'Continue as Guest',
                            icon: Icons.person_outline,
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                AuthSignInAnonymouslyRequested(),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          _LoginButton(
                            label: 'Login with Google',
                            icon: Icons.g_mobiledata,
                            color: Colors.white,
                            textColor: Colors.black,
                            onPressed: () {}, // TODO
                          ),
                          const SizedBox(height: 16),
                          _LoginButton(
                            label: 'Login with Apple',
                            icon: Icons.apple,
                            color: Colors.black,
                            onPressed: () {}, // TODO
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;

  const _LoginButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primary,
          foregroundColor: textColor ?? Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}
