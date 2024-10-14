import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/models/ingrediente.dart';
import 'package:app/database/database_helper.dart';

class IngredientesNotifier extends StateNotifier<List<Ingrediente>> {
  IngredientesNotifier() : super([]) {
    loadIngredients();
  }

  Future<void> loadIngredients() async {
    final db = await getDatabase();
    final data = await db.query('user_ingredients');
    if (data.isNotEmpty) {
      state = data
          .map(
            (row) => Ingrediente(
              nombre: row['name'] as String,
              costo: row['price'] as double,
            ),
          )
          .toList();
    } else {
      state = [];
    }
  }

  Future<void> addIngredient(String nombre, double costo) async {
    final db = await getDatabase();

    final existingIngredient = await db.query(
      'user_ingredients',
      where: 'name = ?',
      whereArgs: [nombre],
    );

    if (existingIngredient.isNotEmpty) {
      await db.update(
        'user_ingredients',
        {'price': costo},
        where: 'name = ?',
        whereArgs: [nombre],
      );
    } else {
      await db.insert(
        'user_ingredients',
        {'name': nombre, 'price': costo},
      );
    }

    await loadIngredients();
  }

  Future<void> deleteIngredient(String nombre) async {
    final db = await getDatabase();

    await db.delete(
      'user_ingredients',
      where: 'name = ?',
      whereArgs: [nombre],
    );

    await loadIngredients();
  }
}

final ingredientesProvider =
    StateNotifierProvider<IngredientesNotifier, List<Ingrediente>>(
  (ref) => IngredientesNotifier(),
);
