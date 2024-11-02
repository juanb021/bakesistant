import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/models/receta.dart';
import 'package:app/models/ingrediente.dart';
import 'package:app/models/empaque.dart';
import 'package:app/database/database_helper.dart';

class RecetasNotifier extends StateNotifier<List<Receta>> {
  RecetasNotifier() : super([]) {
    loadRecetas();
  }

  // Cargar todas las recetas desde la base de datos
  Future<void> loadRecetas() async {
    final db = await getDatabase();
    final data = await db.query('recetas');

    if (data.isNotEmpty) {
      final recetas = await Future.wait(data.map((row) async {
        // Obtener los ingredientes relacionados para cada receta
        final ingredientesData = await db.query(
          'receta_ingredientes',
          where: 'receta_id = ?',
          whereArgs: [row['id']],
        );

        final List<Map<Ingrediente, double>> ingredientList = [];

        for (var ingredienteRow in ingredientesData) {
          final ingredienteData = await db.query(
            'user_ingredients',
            where: 'id = ?',
            whereArgs: [ingredienteRow['ingrediente_id']],
          );

          if (ingredienteData.isNotEmpty) {
            final ingrediente = Ingrediente(
              nombre: ingredienteData.first['name'] as String,
              costo: ingredienteData.first['price'] as double,
            );
            final cantidad = ingredienteRow['cantidad'] as double;

            ingredientList.add({ingrediente: cantidad});
          }
        }

        // Obtener los empaques relacionados para cada receta
        final empaquesData = await db.query(
          'receta_empaques',
          where: 'receta_id = ?',
          whereArgs: [row['id']],
        );

        final List<Map<Empaque, double>> packageList = [];

        for (var empaqueRow in empaquesData) {
          final empaqueData = await db.query(
            'user_empaques',
            where: 'id = ?',
            whereArgs: [empaqueRow['empaque_id']],
          );

          if (empaqueData.isNotEmpty) {
            final empaque = Empaque(
              nombre: empaqueData.first['name'] as String,
              costo: empaqueData.first['price'] as double,
            );
            final cantidad = empaqueRow['cantidad'] as double;

            packageList.add({empaque: cantidad});
          }
        }

        return Receta(
          nombre: row['name'] as String,
          ingredientList: ingredientList,
          packageList: packageList,
          monthlyProduction: row['monthly_production'] as double,
          costoMaterial: row['costo_material'] as double?,
          precioVenta: row['precio_venta'] as double?,
        );
      }).toList());

      state = recetas;
    } else {
      state = [];
    }
  }

  // Agregar o actualizar una receta en la base de datos
  Future<void> addReceta(
    String nombre,
    List<Map<Ingrediente, double>> ingredientList,
    List<Map<Empaque, double>> packageList,
    double monthlyProduction,
  ) async {
    final db = await getDatabase();

    final existingReceta = await db.query(
      'recetas',
      where: 'name = ?',
      whereArgs: [nombre],
    );

    // Calcular el costo total de los ingredientes y empaques
    final receta = Receta(
      nombre: nombre,
      ingredientList: ingredientList,
      packageList: packageList,
      monthlyProduction: monthlyProduction,
    );
    final costoMaterial = receta.getCosto();

    if (existingReceta.isNotEmpty) {
      // Actualizar receta existente
      await db.update(
        'recetas',
        {
          'costo_material': costoMaterial,
          'monthly_production': monthlyProduction,
        },
        where: 'name = ?',
        whereArgs: [nombre],
      );

      // Eliminar los ingredientes y empaques antiguos para actualizar
      final recetaId = existingReceta.first['id'] as int;
      await db.delete(
        'receta_ingredientes',
        where: 'receta_id = ?',
        whereArgs: [recetaId],
      );
      await db.delete(
        'receta_empaques',
        where: 'receta_id = ?',
        whereArgs: [recetaId],
      );
    } else {
      // Insertar nueva receta
      final recetaId = await db.insert(
        'recetas',
        {
          'name': nombre,
          'costo_material': costoMaterial,
          'monthly_production': monthlyProduction,
        },
      );

      // Agregar los ingredientes a la tabla receta_ingredientes
      for (var ingredienteMap in ingredientList) {
        final ingrediente = ingredienteMap.keys.first;
        final cantidad = ingredienteMap[ingrediente]!;

        final ingredienteId = (await db.query(
          'user_ingredients',
          where: 'name = ?',
          whereArgs: [ingrediente.nombre],
        ))
            .first['id'] as int;

        await db.insert(
          'receta_ingredientes',
          {
            'receta_id': recetaId,
            'ingrediente_id': ingredienteId,
            'cantidad': cantidad,
          },
        );
      }

      // Agregar los empaques a la tabla receta_empaques
      for (var packageMap in packageList) {
        final empaque = packageMap.keys.first;
        final cantidad = packageMap[empaque]!;

        final empaqueId = (await db.query(
          'user_empaques',
          where: 'name = ?',
          whereArgs: [empaque.nombre],
        ))
            .first['id'] as int;

        await db.insert(
          'receta_empaques',
          {
            'receta_id': recetaId,
            'empaque_id': empaqueId,
            'cantidad': cantidad,
          },
        );
      }
    }

    await loadRecetas();
  }

  // Eliminar una receta de la base de datos
  Future<void> deleteReceta(String nombre) async {
    final db = await getDatabase();

    final existingReceta = await db.query(
      'recetas',
      where: 'name = ?',
      whereArgs: [nombre],
    );

    if (existingReceta.isNotEmpty) {
      final recetaId = existingReceta.first['id'] as int;

      // Eliminar los ingredientes y empaques de la receta
      await db.delete(
        'receta_ingredientes',
        where: 'receta_id = ?',
        whereArgs: [recetaId],
      );
      await db.delete(
        'receta_empaques',
        where: 'receta_id = ?',
        whereArgs: [recetaId],
      );

      // Eliminar la receta
      await db.delete(
        'recetas',
        where: 'id = ?',
        whereArgs: [recetaId],
      );

      await loadRecetas();
    }
  }

  // Filtrar recetas por nombre
  void filterRecetasByName(String query) {
    state = state.where((receta) {
      return receta.nombre.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Restablecer la lista completa de recetas
  Future<void> resetRecetas() async {
    await loadRecetas();
  }
}

final recetasProvider = StateNotifierProvider<RecetasNotifier, List<Receta>>(
  (ref) => RecetasNotifier(),
);
