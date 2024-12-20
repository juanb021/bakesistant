// Import necessary packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/models/ingredient.dart';
import 'package:app/database/database_helper.dart';

class IngredientsNotifier extends StateNotifier<List<Ingredient>> {
  IngredientsNotifier() : super([]) {
    loadIngredients();
  }

  // Loads ingredients from the database and updates the state
  Future<void> loadIngredients() async {
    final db = await getDatabase();
    final data = await db.query('user_ingredients');
    if (data.isNotEmpty) {
      state = data
          .map(
            (row) => Ingredient(
              name: row['name'] as String,
              cost: row['price'] as double,
            ),
          )
          .toList();
    } else {
      state = [];
    }
  }

  // Adds a new ingredient if it doesn't exist, otherwise updates its cost
  Future<void> addIngredient(String name, double cost) async {
    final db = await getDatabase();

    final existingIngredient = await db.query(
      'user_ingredients',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (existingIngredient.isNotEmpty) {
      await db.update(
        'user_ingredients',
        {'price': cost},
        where: 'name = ?',
        whereArgs: [name],
      );
    } else {
      await db.insert(
        'user_ingredients',
        {'name': name, 'price': cost},
      );
    }

    await loadIngredients();
  }

  // Updates an ingredient's cost in the database if it exists
  Future<void> updateIngredient(
      String oldName, String newName, double newCost) async {
    final db = await getDatabase();

    final ingredientToUpdate = await db.query(
      'user_ingredients',
      where: 'name = ?',
      whereArgs: [oldName],
    );

    if (ingredientToUpdate.isNotEmpty) {
      await db.update(
        'user_ingredients',
        {
          'name': newName, // Update the name
          'price': newCost // Update the cost
        },
        where: 'name = ?',
        whereArgs: [oldName],
      );

      // Update the in-memory list of ingredients to reflect the changes
      state = [
        for (final ingredient in state)
          if (ingredient.name == oldName)
            Ingredient(name: newName, cost: newCost)
          else
            ingredient,
      ];
    }
  }

  // Deletes an ingredient from the database and updates the state
  Future<void> deleteIngredient(String name) async {
    final db = await getDatabase();

    await db.delete(
      'user_ingredients',
      where: 'name = ?',
      whereArgs: [name],
    );

    await loadIngredients();
  }

  // Filters ingredients by name and updates the state based on the search query
  void filterIngredientsByName(String query) {
    state = state.where((ingredient) {
      return ingredient.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Resets the state by reloading all ingredients from the database
  Future<void> resetIngredients() async {
    await loadIngredients();
  }
}

// Provides the IngredientsNotifier state
final ingredientsProvider =
    StateNotifierProvider<IngredientsNotifier, List<Ingredient>>(
  (ref) => IngredientsNotifier(),
);
