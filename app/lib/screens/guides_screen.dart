import 'package:app/screens/guide_details.dart';
import 'package:flutter/material.dart';

import 'package:app/models/guia.dart';
import 'package:app/data/datos_guia.dart';

class GuidesScreen extends StatelessWidget {
  const GuidesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    void openGuideDetails(Guia guia) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => GuideDetails(
                guia: guia,
              )));
    }

    const List<Guia> guias = infoGuias;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryFixed,
          title: Text(
            'Guias de uso',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            for (final guia in guias)
              InkWell(
                onTap: () {
                  openGuideDetails(guia);
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    '●  ${guia.titulo.toUpperCase()}  ●',
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
          ],
        ));
  }
}
