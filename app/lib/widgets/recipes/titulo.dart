import 'package:flutter/material.dart';

class Titulo extends StatelessWidget {
  const Titulo({
    super.key,
    required this.titulo,
  });

  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          titulo,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
