import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/models/package.dart';
import 'package:app/database/database_helper.dart';

class PackagesNotifier extends StateNotifier<List<Package>> {
  PackagesNotifier() : super([]) {
    loadPackages();
  }

  // Carga los empaques desde la base de datos y actualiza el estado
  Future<void> loadPackages() async {
    final db = await getDatabase();
    final data = await db.query('user_empaques');
    if (data.isNotEmpty) {
      state = data
          .map(
            (row) => Package(
              name: row['name'] as String,
              cost: row['price'] as double,
            ),
          )
          .toList();
    } else {
      state = [];
    }
  }

  // Agrega o actualiza un empaque en la base de datos y recarga la lista de empaques
  Future<void> addPackage(String name, double cost) async {
    final db = await getDatabase();

    final existingPackage = await db.query(
      'user_empaques',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (existingPackage.isNotEmpty) {
      await db.update(
        'user_empaques',
        {'price': cost},
        where: 'name = ?',
        whereArgs: [name],
      );
    } else {
      await db.insert(
        'user_empaques',
        {'name': name, 'price': cost},
      );
    }

    await loadPackages();
  }

  // Actualiza el nombre y el costo de un empaque en la base de datos y el estado
  Future<void> updatePackage(
      String oldName, String newName, double newCost) async {
    final db = await getDatabase();

    final packageToUpdate = await db.query(
      'user_empaques',
      where: 'name = ?',
      whereArgs: [oldName],
    );

    if (packageToUpdate.isNotEmpty) {
      await db.update(
        'user_empaques',
        {
          'name': newName, // Actualiza el nombre
          'price': newCost // Actualiza el costo
        },
        where: 'name = ?',
        whereArgs: [oldName],
      );

      // Actualiza la lista en memoria de empaques para reflejar los cambios
      state = [
        for (final package in state)
          if (package.name == oldName)
            Package(name: newName, cost: newCost)
          else
            package,
      ];
    }
  }

  // Elimina un empaque de la base de datos y actualiza el estado
  Future<void> deletePackage(String name) async {
    final db = await getDatabase();

    await db.delete(
      'user_empaques',
      where: 'name = ?',
      whereArgs: [name],
    );

    await loadPackages();
  }

  // Filtra los empaques por nombre y actualiza el estado según la consulta de búsqueda
  void filterPackagesByName(String query) {
    state = state.where((package) {
      return package.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Restablece la lista de empaques recargando todos los empaques desde la base de datos
  Future<void> resetPackages() async {
    await loadPackages();
  }
}

// Proveedor de Riverpod para PackagesNotifier
final packagesProvider = StateNotifierProvider<PackagesNotifier, List<Package>>(
  (ref) => PackagesNotifier(),
);
