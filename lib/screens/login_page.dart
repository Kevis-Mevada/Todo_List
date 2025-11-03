import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:todo_app/services/auth_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF1A1A2E), const Color(0xFF16213E).withOpacity(0.8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Icon
              const Icon(
                Icons.check_circle_outline_rounded,
                size: 120,
                color: Color(0xFF9B59B6),
              )
                  .animate()
                  .fade(duration: 800.ms)
                  .scale(delay: 200.ms, duration: 600.ms, curve: Curves.easeOutBack),

              const SizedBox(height: 20),

              // App Title
              Text(
                'TaskFlow',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              )
                  .animate()
                  .fade(delay: 500.ms, duration: 800.ms)
                  .slideY(begin: 0.5, end: 0, curve: Curves.easeInOut),

              const SizedBox(height: 10),

              // App Subtitle
              Text(
                'Your daily task manager',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white70,
                ),
              )
                  .animate()
                  .fade(delay: 700.ms, duration: 800.ms)
                  .slideY(begin: 0.5, end: 0, curve: Curves.easeInOut),

              SizedBox(height: size.height * 0.2),

              // Google Sign-In Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  elevation: 5,
                ),
                // This line uses an online image, which will fix the error.
                icon: Image.network('https://img.icons8.com/color/48/000000/google-logo.png', height: 24.0),
                label: const Text(
                  'Continue with Google',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onPressed: () async {
                  await authService.signInWithGoogle();
                },
              )
                  .animate()
                  .fade(delay: 1200.ms, duration: 800.ms)
                  .slideY(begin: 1, end: 0, curve: Curves.easeOutCubic),
            ],
          ),
        ),
      ),
    );
  }
}

