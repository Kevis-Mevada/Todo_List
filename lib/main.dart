import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/auth_wrapper.dart';
import 'firebase_options.dart';

void main() async {
  // Ensure Flutter is ready before doing anything else.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for our project.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ToDo App',
      debugShowCheckedModeBanner: false,
      // Define a modern, dark theme for the entire app.
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF8E44AD),
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF9B59B6),
          secondary: Color(0xFFE74C3C),
          surface: Color(0xFF2C3E50),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        )),
        useMaterial3: true,
      ),
      home: AuthWrapper(),
    );
  }
}
