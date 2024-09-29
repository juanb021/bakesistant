import 'package:app/screens/guide_details.dart';
import 'package:flutter/material.dart';

import 'package:app/models/guia.dart';
import 'package:app/data/datos_guia.dart';

class GuidesScreen extends StatelessWidget {
  const GuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void openGuideDetails(Guia guia) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => GuideDetails(
            guia: guia,
          ),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryFixed,
          title: Text(
            'Ayuda',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        body: ListView.builder(
          itemCount: infoGuias.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              openGuideDetails(infoGuias[index]);
            },
            child: Card(
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Theme.of(context).colorScheme.primaryFixed,
                  Theme.of(context).colorScheme.primaryFixedDim,
                ])),
                child: Text(
                  infoGuias[index].titulo,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
