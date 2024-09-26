import 'package:app/models/guia.dart';
import 'package:flutter/material.dart';

class GuideDetails extends StatelessWidget {
  const GuideDetails({
    super.key,
    required this.guia,
  });

  final Guia guia;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(guia.titulo),
        backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Text(
            guia.contenido,
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
