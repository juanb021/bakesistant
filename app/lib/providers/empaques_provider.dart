import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/models/empaque.dart';
import 'package:app/database/database_helper.dart';

class EmpaquesNotifier extends StateNotifier<List<Empaque>> {
  EmpaquesNotifier() : super([]) {
    loadEmpaques();
  }

  Future<void> loadEmpaques() async {
    final db = await getDatabase();
    final data = await db.query('user_empaques');
    if (data.isNotEmpty) {
      state = data
          .map(
            (row) => Empaque(
              nombre: row['name'] as String,
              costo: row['price'] as double,
            ),
          )
          .toList();
    } else {
      state = [];
    }
  }

  Future<void> addEmpaque(String nombre, double costo) async {
    final db = await getDatabase();

    final existingEmpaque = await db.query(
      'user_empaques',
      where: 'name = ?',
      whereArgs: [nombre],
    );

    if (existingEmpaque.isNotEmpty) {
      await db.update(
        'user_empaques',
        {'price': costo},
        where: 'name = ?',
        whereArgs: [nombre],
      );
    } else {
      await db.insert(
        'user_empaques',
        {'name': nombre, 'price': costo},
      );
    }

    await loadEmpaques();
  }

  Future<void> deleteEmpaque(String nombre) async {
    final db = await getDatabase();

    await db.delete(
      'user_empaques',
      where: 'name = ?',
      whereArgs: [nombre],
    );

    await loadEmpaques();
  }

  void filterEmpaquesByName(String query) {
    state = state.where((empaque) {
      return empaque.nombre.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Nuevo método para reiniciar el estado con todos los ingredientes
  Future<void> resetEmpaques() async {
    await loadEmpaques();
  }
}

final empaquesProvider = StateNotifierProvider<EmpaquesNotifier, List<Empaque>>(
  (ref) => EmpaquesNotifier(),
);
