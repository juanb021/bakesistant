import 'package:app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

ThemeData tema = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 63, 224, 208),
  ),
);

void main() {
  runApp(
    const ProviderScope(
      child: Bakesistant(),
    ),
  );
}

class Bakesistant extends StatelessWidget {
  const Bakesistant({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bakesistant',
      theme: tema,
      home: const HomeScreen(),
    );
  }
}
