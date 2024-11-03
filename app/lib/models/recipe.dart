// Modules
import 'package:app/models/package.dart';
import 'package:app/models/ingredient.dart';

class Recipe {
  Recipe({
    required this.name,
    required this.ingredientList,
    required this.packageList,
    required this.monthlyProduction,
    this.materialCost,
    this.salePrice,
  });

  final String name;
  final List<Map<Ingredient, double>> ingredientList;
  final List<Map<Package, double>> packageList;
  final double monthlyProduction;
  double? materialCost;
  double? salePrice;

  double getCost() {
    double totalCost = 0;

    for (final ingredientMap in ingredientList) {
      final ingredient = ingredientMap.keys.first;
      final amount = ingredientMap[ingredient] ?? 0;

      totalCost += ingredient.cost * amount;
    }
    for (final packageMap in packageList) {
      final package = packageMap.keys.first;
      final amount = packageMap[package] ?? 0;

      totalCost += package.cost * amount;
    }

    materialCost = totalCost;

    return materialCost!;
  }
}
