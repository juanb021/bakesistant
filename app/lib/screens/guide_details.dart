// Libraries
import 'package:flutter/material.dart';

// Modules
import 'package:app/models/guide.dart';

class GuideDetails extends StatelessWidget {
  const GuideDetails({
    super.key,
    required this.guide,
  });

  final Guide guide;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(guide.titulo),
        backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Text(
            guide.contenido,
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
