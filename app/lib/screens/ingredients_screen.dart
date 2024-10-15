import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/models/ingrediente.dart';
import 'package:app/providers/ingredients_provider.dart';
import 'package:app/widgets/ingredients/ingredient_info.dart';
import 'package:app/widgets/ingredients/ingredient_form.dart';

class IngredientsScreen extends ConsumerStatefulWidget {
  const IngredientsScreen({super.key});

  @override
  ConsumerState<IngredientsScreen> createState() {
    return _IngredientsScreenState();
  }
}

class _IngredientsScreenState extends ConsumerState<IngredientsScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _openAddIngredientoverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => const IngredientForm(),
    );
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      ref.read(ingredientesProvider.notifier).filterIngredientsByName(query);
    } else {
      ref.read(ingredientesProvider.notifier).resetIngredients();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Ingrediente> ingredientes = ref.watch(ingredientesProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryFixed,
          title: Text(
            'Lista de ingredientes',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          actions: [
            IconButton(
              onPressed: _openAddIngredientoverlay,
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.primary,
                size: 34,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.help_outline,
                color: Theme.of(context).colorScheme.primary,
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
                  labelText: 'Buscar ingrediente...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
            ingredientes.isNotEmpty
                ? Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Nombre',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Precio',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: ingredientes.length,
                            itemBuilder: (ctx, index) => IngredientInfo(
                              ingrediente: ingredientes[index],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const Center(
                    child: Text('Ningún ingrediente!'),
                  ),
          ],
        ),
      ),
    );
  }
}
