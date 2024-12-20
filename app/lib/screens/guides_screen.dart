// Libraries
import 'package:app/screens/guide_details.dart';
import 'package:flutter/material.dart';

// Modules
import 'package:app/models/guide.dart';
import 'package:app/data/guide_data.dart';

class GuidesScreen extends StatelessWidget {
  const GuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Function to open the details of a selected guide
    void openGuideDetails(Guide guide) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => GuideDetails(
            guide: guide,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text(
          'Ayuda',
          style: TextStyle(color: Colors.white),
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
              color: Theme.of(context).colorScheme.secondary,
              child: Text(
                infoGuias[index].titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
