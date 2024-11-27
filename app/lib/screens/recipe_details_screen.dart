import 'package:app/models/recipe.dart';
import 'package:app/providers/expenses_notifier.dart';
import 'package:app/widgets/recipes/new_recipe_form.dart';
import 'package:app/widgets/recipes/recipe_profit_controller.dart';
import 'package:app/widgets/recipes/recipe_quantity_controller.dart';
import 'package:app/widgets/recipes/recipe_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeDetailsScreen extends ConsumerStatefulWidget {
  const RecipeDetailsScreen({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  ConsumerState<RecipeDetailsScreen> createState() {
    return _RecetaDetallesState();
  }
}

class _RecetaDetallesState extends ConsumerState<RecipeDetailsScreen> {
  int quantity = 1;
  int packagequantity = 1;
  double proffitMargin = 0.0;
  double totalWithEarnings = 0.0;
  double materialsCost = 0.0;
  double packagingCost = 0.0;

  void _onQuantityChange(int input) {
    setState(() {
      quantity = input > 0 ? input : 1;

      // Calcula el costo total de materiales
      materialsCost =
          widget.recipe.ingredientList.fold(0.0, (sum, ingredienteMap) {
        final ingredient = ingredienteMap.keys.first;
        final ingredientQuantity = ingredienteMap.values.first;
        final ingredientCost = ingredient.cost / 1000;

        // Calcula el costo total del ingredient considerando la quantity
        return sum + (ingredientCost * ingredientQuantity * quantity);
      });
    });
  }

  void _onPackageChange(int input) {
    setState(() {
      packagequantity = input > 0 ? input : 1;

      // Calcula el costo total de empaques
      packagingCost = widget.recipe.packageList.fold(0.0, (sum, empaqueMap) {
        final packaging = empaqueMap.keys.first;
        final packagingQuantity = empaqueMap.values.first;
        final packagingCost = packaging.cost;

        // Calcula el costo total del packaging considerando la quantity de empaques
        return sum + (packagingCost * packagingQuantity * packagequantity);
      });
    });
  }

  void _onPercentChanged(double percent) {
    setState(() {
      proffitMargin = percent;
    });
  }

  double _calcularCostoTotal(double expenses, double monthlyProduction) {
    double staticCost = expenses / monthlyProduction;
    return materialsCost + packagingCost + staticCost;
  }

  @override
  Widget build(BuildContext context) {
    final double expenses =
        ref.read(expensesProvider.notifier).calculateTotalExpenses();
    final Recipe recipe = widget.recipe;
    final String totalCost =
        _calcularCostoTotal(expenses, recipe.monthlyProduction)
            .toStringAsFixed(2);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          recipe.name,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navega a NewRecetaForm para editar la recipe
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (ctx) => NewRecipeForm(
                        receta: recipe,
                      )));
            },
            icon: const Icon(
              Icons.edit_note,
              size: 34,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RecipeQuantityController(
                onIngredientChange: _onQuantityChange,
                onPackagingChange: _onPackageChange),
            const RecipeRow(
              textA: 'Ingrediente',
              textB: 'Cantidad',
              textC: 'Costo',
              isBold: true,
              size: 18,
            ),
            for (final ingredienteMap in recipe.ingredientList)
              RecipeRow(
                textA: ingredienteMap.keys.first.name,
                textB:
                    (ingredienteMap.values.first * quantity).toStringAsFixed(0),
                textC: ((ingredienteMap.keys.first.cost / 1000) *
                        (ingredienteMap.values.first * quantity))
                    .toStringAsFixed(3),
                isBold: false,
                size: 16,
              ),
            RecipeRow(
                textA: 'Costo de materiales',
                textB: '',
                textC: materialsCost.toStringAsFixed(2),
                isBold: true,
                size: 18),
            const RecipeRow(
                textA: 'Empaque',
                textB: 'Cantidad',
                textC: 'Costo',
                isBold: true,
                size: 18),
            for (final empaqueMap in recipe.packageList)
              RecipeRow(
                  textA: empaqueMap.keys.first.name,
                  textB: (empaqueMap.values.first * packagequantity)
                      .toStringAsFixed(0),
                  textC: (empaqueMap.keys.first.cost * packagequantity)
                      .toStringAsFixed(3),
                  isBold: false,
                  size: 16),
            RecipeRow(
                textA: 'Costo fijo por unidad',
                textB: '',
                textC: (expenses / recipe.monthlyProduction).toStringAsFixed(2),
                isBold: true,
                size: 18),
            RecipeRow(
                textA: 'Costo Total',
                textB: '',
                textC: totalCost.toString(),
                isBold: true,
                size: 18),
            RecipeProfitController(onProfitChange: _onPercentChanged),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Precio de venta: \$${(double.parse(totalCost) * (1 + proffitMargin / 100)).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
