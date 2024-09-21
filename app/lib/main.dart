import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return const MaterialApp(
      title: 'Bakesistant',
      home: Scaffold(
        body: Center(
          child: Text('Placeholder'),
        ),
      ),
    );
  }
}
