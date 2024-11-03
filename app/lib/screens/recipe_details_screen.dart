import 'package:app/models/recipe.dart';
import 'package:app/providers/expenses_notifier.dart';
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

  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _packagingController = TextEditingController();
  final TextEditingController _percentController = TextEditingController();

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
        backgroundColor: Theme.of(context).colorScheme.primaryFixed,
        title: Text(
          recipe.name,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navega a NewRecetaForm para editar la recipe
            },
            icon: const Icon(
              Icons.edit_note,
              size: 34,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: 'Cantidad de unidades',
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        prefixIcon: Icon(
                          Icons.bakery_dining_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 34,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final int? input = int.tryParse(value);
                        if (input != null) {
                          _onQuantityChange(input);
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
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        prefixIcon: Icon(
                          Icons.shopping_bag,
                          color: Theme.of(context).colorScheme.primary,
                          size: 34,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final int? input = int.tryParse(value);
                        if (input != null) {
                          _onPackageChange(input);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Ingrediente',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      'Cantidad',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Costo',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            for (final ingredienteMap in recipe.ingredientList)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        ingredienteMap.keys.first.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        (ingredienteMap.values.first * quantity)
                            .toStringAsFixed(0),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        ((ingredienteMap.keys.first.cost / 1000) *
                                (ingredienteMap.values.first * quantity))
                            .toStringAsFixed(3),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Costo de materiales',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      materialsCost.toStringAsFixed(3),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Nueva sección de empaques
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Empaque',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      'Cantidad',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Costo',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            for (final empaqueMap in recipe.packageList)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        empaqueMap.keys.first.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        (empaqueMap.values.first * packagequantity)
                            .toStringAsFixed(0),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        (empaqueMap.keys.first.cost * packagequantity)
                            .toStringAsFixed(3),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Costo fijo por unidad',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      (expenses / recipe.monthlyProduction).toStringAsFixed(2),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Costo Total',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      totalCost.toString(),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _percentController,
                decoration: InputDecoration(
                  labelText: 'Porcentaje de Ganancia',
                  prefixIcon: const Icon(Icons.percent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final double? input = double.tryParse(value);
                  if (input != null) {
                    _onPercentChanged(input);
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Precio de venta: \$${(double.parse(totalCost) * (1 + proffitMargin / 100)).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
