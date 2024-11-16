// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Modules
import 'package:app/screens/home_screen.dart';

// Defines the main theme of the application, using a color scheme generated from a seed color
ThemeData theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(
        255, 63, 224, 208), // Adjust this color to change the theme
  ),
);
void main() {
  runApp(
    const ProviderScope(
      child:
          // Initializes the app within ProviderScope for Riverpod
          Bakesistant(),
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
      home: const HomeScreen(),
    );
  }
}
