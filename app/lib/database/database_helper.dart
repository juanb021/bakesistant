import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart' as sql;

Future<Database> getDatabase() async {
  final dbpath = await sql.getDatabasesPath();
  return sql.openDatabase(
    path.join(dbpath, 'bakesistant.db'),
    onCreate: (db, version) async {
      // Create user_expenses table
      await db.execute("""
          CREATE TABLE IF NOT EXISTS user_expenses (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          alquiler REAL,
          depreciacion REAL,
          gventas REAL,
          nomina REAL,
          papeleria REAL,
          servicios REAL,
          total REAL
        )""");

      // Create user_ingredients table
      await db.execute("""
          CREATE TABLE IF NOT EXISTS user_ingredients (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT UNIQUE,
          price REAL
        )""");

      // Create recetas table
      await db.execute("""
          CREATE TABLE IF NOT EXISTS recetas (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT UNIQUE,
          costo_material REAL,
          monthly_production REAL
        )""");

      // Create receta_ingredientes table for many-to-many relation
      await db.execute("""
          CREATE TABLE IF NOT EXISTS receta_ingredientes (
          receta_id INTEGER,
          ingrediente_id INTEGER,
          cantidad REAL,
          FOREIGN KEY (receta_id) REFERENCES recetas(id),
          FOREIGN KEY (ingrediente_id) REFERENCES user_ingredients(id),
          PRIMARY KEY (receta_id, ingrediente_id)
        )""");

      // Create user_packages table
      await db.execute("""
          CREATE TABLE IF NOT EXISTS user_empaques (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT UNIQUE,
          price REAL
        )""");

      // Create receta_empaques table for many-to-many relation
      await db.execute("""
          CREATE TABLE IF NOT EXISTS receta_empaques (
          receta_id INTEGER,
          empaque_id INTEGER,
          cantidad REAL,
          FOREIGN KEY (receta_id) REFERENCES recetas(id),
          FOREIGN KEY (empaque_id) REFERENCES user_empaques(id),
          PRIMARY KEY (receta_id, empaque_id)
        )""");
    },
    version: 1,
  );
}

Future<void> deleteDatabase() async {
  final dbpath = await sql.getDatabasesPath();
  await sql.deleteDatabase(path.join(dbpath, 'bakesistant.db'));
}
