import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/models/recipe.dart';
import 'package:app/models/ingredient.dart';
import 'package:app/models/package.dart';
import 'package:app/database/database_helper.dart';

class RecipesNotifier extends StateNotifier<List<Recipe>> {
  RecipesNotifier() : super([]) {
    loadRecipes();
  }

  // Load all recipes from the database
  Future<void> loadRecipes() async {
    final db = await getDatabase();
    final data = await db.query('recetas');

    if (data.isNotEmpty) {
      final recipes = await Future.wait(data.map((row) async {
        // Retrieve ingredients related to each recipe
        final ingredientsData = await db.query(
          'receta_ingredientes',
          where: 'receta_id = ?',
          whereArgs: [row['id']],
        );

        final List<Map<Ingredient, double>> ingredientList = [];

        for (var ingredientRow in ingredientsData) {
          final ingredientData = await db.query(
            'user_ingredients',
            where: 'id = ?',
            whereArgs: [ingredientRow['ingrediente_id']],
          );

          if (ingredientData.isNotEmpty) {
            final ingredient = Ingredient(
              name: ingredientData.first['name'] as String,
              cost: ingredientData.first['price'] as double,
            );
            final quantity = ingredientRow['cantidad'] as double;

            ingredientList.add({ingredient: quantity});
          }
        }

        // Retrieve packages related to each recipe
        final packagesData = await db.query(
          'receta_empaques',
          where: 'receta_id = ?',
          whereArgs: [row['id']],
        );

        final List<Map<Package, double>> packageList = [];

        for (var packageRow in packagesData) {
          final packageData = await db.query(
            'user_empaques',
            where: 'id = ?',
            whereArgs: [packageRow['empaque_id']],
          );

          if (packageData.isNotEmpty) {
            final package = Package(
              name: packageData.first['name'] as String,
              cost: packageData.first['price'] as double,
            );
            final quantity = packageRow['cantidad'] as double;

            packageList.add({package: quantity});
          }
        }

        return Recipe(
          name: row['name'] as String,
          ingredientList: ingredientList,
          packageList: packageList,
          monthlyProduction: row['monthly_production'] as double,
          materialCost: row['costo_material'] as double?,
          salePrice: row['precio_venta'] as double?,
        );
      }).toList());

      state = recipes;
    } else {
      state = [];
    }
  }

  // Add or update a recipe in the database
  Future<void> addRecipe(
    String name,
    List<Map<Ingredient, double>> ingredientList,
    List<Map<Package, double>> packageList,
    double monthlyProduction,
  ) async {
    final db = await getDatabase();

    final existingRecipe = await db.query(
      'recetas',
      where: 'name = ?',
      whereArgs: [name],
    );

    // Calculate the total cost of ingredients and packages
    final recipe = Recipe(
      name: name,
      ingredientList: ingredientList,
      packageList: packageList,
      monthlyProduction: monthlyProduction,
    );
    final materialCost = recipe.getCost();

    if (existingRecipe.isNotEmpty) {
      // Update existing recipe
      await db.update(
        'recetas',
        {
          'costo_material': materialCost,
          'monthly_production': monthlyProduction,
        },
        where: 'name = ?',
        whereArgs: [name],
      );

      // Delete old ingredients and packages for update
      final recipeId = existingRecipe.first['id'] as int;
      await db.delete(
        'receta_ingredientes',
        where: 'receta_id = ?',
        whereArgs: [recipeId],
      );
      await db.delete(
        'receta_empaques',
        where: 'receta_id = ?',
        whereArgs: [recipeId],
      );
    } else {
      // Insert new recipe
      final recipeId = await db.insert(
        'recetas',
        {
          'name': name,
          'costo_material': materialCost,
          'monthly_production': monthlyProduction,
        },
      );

      // Add ingredients to receta_ingredientes table
      for (var ingredientMap in ingredientList) {
        final ingredient = ingredientMap.keys.first;
        final quantity = ingredientMap[ingredient]!;

        final ingredientId = (await db.query(
          'user_ingredients',
          where: 'name = ?',
          whereArgs: [ingredient.name],
        ))
            .first['id'] as int;

        await db.insert(
          'receta_ingredientes',
          {
            'receta_id': recipeId,
            'ingrediente_id': ingredientId,
            'cantidad': quantity,
          },
        );
      }

      // Add packages to receta_empaques table
      for (var packageMap in packageList) {
        final package = packageMap.keys.first;
        final quantity = packageMap[package]!;

        final packageId = (await db.query(
          'user_empaques',
          where: 'name = ?',
          whereArgs: [package.name],
        ))
            .first['id'] as int;

        await db.insert(
          'receta_empaques',
          {
            'receta_id': recipeId,
            'empaque_id': packageId,
            'cantidad': quantity,
          },
        );
      }
    }

    await loadRecipes();
  }

  // Delete a recipe from the database
  Future<void> deleteRecipe(String name) async {
    final db = await getDatabase();

    final existingRecipe = await db.query(
      'recetas',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (existingRecipe.isNotEmpty) {
      final recipeId = existingRecipe.first['id'] as int;

      // Delete ingredients and packages for the recipe
      await db.delete(
        'receta_ingredientes',
        where: 'receta_id = ?',
        whereArgs: [recipeId],
      );
      await db.delete(
        'receta_empaques',
        where: 'receta_id = ?',
        whereArgs: [recipeId],
      );

      // Delete the recipe
      await db.delete(
        'recetas',
        where: 'id = ?',
        whereArgs: [recipeId],
      );

      await loadRecipes();
    }
  }

  // Filter recipes by name
  void filterRecipesByName(String query) {
    state = state.where((recipe) {
      return recipe.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Reset the full list of recipes
  Future<void> resetRecipes() async {
    await loadRecipes();
  }
}

final recipesProvider = StateNotifierProvider<RecipesNotifier, List<Recipe>>(
  (ref) => RecipesNotifier(),
);
