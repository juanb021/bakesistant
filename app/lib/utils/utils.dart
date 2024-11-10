import 'package:app/models/package.dart';
import 'package:app/models/ingredient.dart';

// Functions for NewRecipeForm
List<Package> getAvaiablePackages(
  int index,
  List<Package> packageList,
  List<Map<String, dynamic>> packageQuanity,
) {
  final Set<dynamic> selectedPackages = packageQuanity
      .asMap()
      .entries
      .where((entry) => entry.key != index)
      .map((entry) => entry.value["empaque"])
      .toSet();

  return packageList
      .where((package) => !selectedPackages.contains(package))
      .toSet()
      .toList();
}

List<Ingredient> getAvaiableIngredients(
  int index,
  List<Ingredient> ingredientList,
  List<Map<String, dynamic>> ingredientQuanity,
) {
  final Set<dynamic> selectedIngredients = ingredientQuanity
      .asMap()
      .entries
      .where((entry) => entry.key != index)
      .map((entry) => entry.value["ingrediente"])
      .toSet();

  return ingredientList
      .where((ingredient) => !selectedIngredients.contains(ingredient))
      .toSet()
      .toList();
}
