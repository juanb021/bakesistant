import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/models/package.dart';
import 'package:app/database/database_helper.dart';

class PackagesNotifier extends StateNotifier<List<Package>> {
  PackagesNotifier() : super([]) {
    loadPackages();
  }

  // Loads packages from the database and updates the state
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

  // Adds or updates a package in the database, then reloads all packages
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

  // Deletes a package from the database by name, then reloads all packages
  Future<void> deletePackage(String name) async {
    final db = await getDatabase();

    await db.delete(
      'user_empaques',
      where: 'name = ?',
      whereArgs: [name],
    );

    await loadPackages();
  }

  // Filters the list of packages by name, updating the state
  void filterPackagesByName(String query) {
    state = state.where((package) {
      return package.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Resets the package list by reloading all packages from the database
  Future<void> resetPackages() async {
    await loadPackages();
  }
}

// Provides an instance of PackagesNotifier as a Riverpod provider
final packagesProvider = StateNotifierProvider<PackagesNotifier, List<Package>>(
  (ref) => PackagesNotifier(),
);
