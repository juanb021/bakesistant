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
  void _openAddIngredientoverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => const IngredientForm(),
    );
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
        body: ingredientes.isNotEmpty
            ? ListView.builder(
                itemCount: ingredientes.length,
                itemBuilder: (ctx, index) => IngredientInfo(
                  ingrediente: ingredientes[index],
                ),
              )
            : const Center(
                child: Text(
                  'Ningun ingrediente!',
                ),
              ),
      ),
    );
  }
}
