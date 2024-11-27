import 'package:flutter/material.dart';

class RecipeQuantityController extends StatefulWidget {
  const RecipeQuantityController({
    super.key,
    required this.onIngredientChange,
    required this.onPackagingChange,
  });

  final void Function(int) onIngredientChange;
  final void Function(int) onPackagingChange;

  @override
  State<RecipeQuantityController> createState() {
    return __RecipeQuantityControllerState();
  }
}

class __RecipeQuantityControllerState extends State<RecipeQuantityController> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _packagingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Cantidad de unidades',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: Icon(
                  Icons.bakery_dining_rounded,
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                  size: 34,
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final int? input = int.tryParse(value);
                if (input != null) {
                  widget.onIngredientChange(input);
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _packagingController,
              decoration: InputDecoration(
                labelText: 'Cantidad de empaques',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: Icon(
                  Icons.shopping_bag,
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                  size: 34,
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final int? input = int.tryParse(value);
                if (input != null) {
                  widget.onPackagingChange(input);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
