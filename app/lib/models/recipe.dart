// Modules
import 'package:app/models/package.dart';
import 'package:app/models/ingredient.dart';

class Recipe {
  int? id; // Cambiado a opcional
  String name;
  List<Map<Ingredient, double>> ingredientList;
  List<Map<Package, double>> packageList;
  double monthlyProduction;
  double? materialCost;
  double? salePrice;

  Recipe({
    this.id, // id opcional
    required this.name,
    required this.ingredientList,
    required this.packageList,
    required this.monthlyProduction,
    this.materialCost,
    this.salePrice,
  });

  double getCost() {
    // Implementación del cálculo
    return 0.0; // Ejemplo
  }
}
