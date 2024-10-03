import 'package:app/widgets/ingredients/ingredient_info.dart';
import 'package:flutter/material.dart';

import 'package:app/widgets/ingredients/ingredient_form.dart';
import 'package:app/data/dummy_data_ingredients.dart';

class IngredientsScreen extends StatefulWidget {
  const IngredientsScreen({super.key});
  @override
  State<IngredientsScreen> createState() {
    return _IngredientsScreenState();
  }
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  void _openAddIngredientoverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => const IngredientForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        body: ListView.builder(
          itemCount: dummyIngredients.length,
          itemBuilder: (context, index) => IngredientInfo(
            ingrediente: dummyIngredients[index],
          ),
        ),
      ),
    );
  }
}
