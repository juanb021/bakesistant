// Libraries
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Modules
import 'package:app/screens/home_screen.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/firebase_options.dart'; // Generated file by FlutterFire CLI

// Defines the main theme of the application, using a color scheme generated from a seed color
final ThemeData theme = ThemeData(
  colorScheme: ThemeData.light().colorScheme.copyWith(
        primary: const Color.fromARGB(255, 249, 176, 20),
        secondary: const Color.fromARGB(255, 58, 171, 72),
        tertiary: const Color.fromARGB(255, 245, 245, 245),
      ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        backgroundColor:
            const Color.fromARGB(255, 249, 176, 20), // Usa el color primario
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold) // Color del texto/icono
        ),
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures widgets are initialized
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform, // Use the generated options
  );

  runApp(
    const ProviderScope(
      child:
          Bakesistant(), // Initializes the app within ProviderScope for Riverpod
    ),
  );
}

class Bakesistant extends StatelessWidget {
  const Bakesistant({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bakesistant',
      theme: theme,
      home: const AuthHandler(),
    );
  }
}

class AuthHandler extends StatelessWidget {
  const AuthHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Listens to auth state
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for auth state
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          // User is authenticated, show the HomeScreen
          return const HomeScreen();
        } else {
          // User is not authenticated, show the LoginScreen
          return const LoginScreen();
        }
      },
    );
  }
}
