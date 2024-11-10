import 'package:app/models/recipe.dart';
import 'package:app/providers/recipes_provider.dart';
import 'package:app/widgets/recipes/new_recipe_form.dart';
import 'package:app/widgets/recipes/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipesScreen extends ConsumerStatefulWidget {
  const RecipesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _RecetasScreenState();
  }
}

class _RecetasScreenState extends ConsumerState<RecipesScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      ref.read(recipesProvider.notifier).filterRecipesByName(query);
    } else {
      ref.read(recipesProvider.notifier).resetRecipes();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addReceta() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => const NewRecipeForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Recipe> recetas = ref.watch(recipesProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryFixed,
          title: Text(
            'Tus Recetas',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          actions: [
            IconButton(
              onPressed: _addReceta,
              icon: const Icon(
                Icons.add,
                size: 34,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Buscar Receta...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
            Expanded(
              child: recetas.isNotEmpty
                  ? ListView.builder(
                      itemCount: recetas.length,
                      itemBuilder: (ctx, index) {
                        return RecetaCard(receta: recetas[index]);
                      },
                    )
                  : const Center(
                      child: Text(
                        '¡Ninguna Receta!',
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
