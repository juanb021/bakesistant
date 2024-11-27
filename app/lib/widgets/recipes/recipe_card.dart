import 'package:app/models/recipe.dart';
import 'package:app/providers/recipes_provider.dart';
import 'package:app/screens/recipe_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecetaCard extends ConsumerStatefulWidget {
  const RecetaCard({
    super.key,
    required this.receta,
  });

  final Recipe receta;

  @override
  ConsumerState<RecetaCard> createState() {
    return _RecetaCardState();
  }
}

class _RecetaCardState extends ConsumerState<RecetaCard> {
  void _openDetails() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => RecipeDetailsScreen(recipe: widget.receta)));
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.receta.name),
      onDismissed: (direction) {
        ref.read(recipesProvider.notifier).deleteRecipeById(widget.receta.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Receta eliminada!',
            ),
          ),
        );
      },
      child: InkWell(
        onTap: _openDetails,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 25),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.onTertiaryContainer,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.receta.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
