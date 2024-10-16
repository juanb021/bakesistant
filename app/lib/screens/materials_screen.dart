import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MaterialsScreen extends ConsumerStatefulWidget {
  const MaterialsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MaterialsScreenState();
  }
}

class _MaterialsScreenState extends ConsumerState<MaterialsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Placeholder...'),
      ),
    );
  }
}
