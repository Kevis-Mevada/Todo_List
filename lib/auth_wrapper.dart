import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/home_page.dart';
import 'package:todo_app/screens/login_page.dart';
import 'package:todo_app/services/auth_service.dart';

class AuthWrapper extends StatelessWidget {
  final AuthService _authService = AuthService();

  AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading screen while checking auth state
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData) {
          // If user is logged in, show the home page
          return HomePage(user: snapshot.data!);
        } else {
          // If user is not logged in, show the login page
          return const LoginPage();
        }
      },
    );
  }
}
