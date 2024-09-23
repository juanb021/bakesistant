import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/models/gastos_administrativos.dart';

Future<Database> _getDatabase() async {
  final dbpath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbpath, 'bakesistant.db'),
    onCreate: (db, version) {
      return db.execute("""CREATE TABLE user_expenses(
          id PRIMARY KEY,
          alquiler REAL,
          depreciacion REAL,
          gventas REAl,
          nomina REAL,
          papeleria REAL,
          servicios REAL,
          total REAL)""");
    },
    version: 1,
  );
  return db;
}

class GastosNotifier extends StateNotifier<GastosAdministrativos> {
  GastosNotifier()
      : super(
          GastosAdministrativos(
            alquiler: 0,
            depreciacion: 0,
            gVentas: 0,
            nomina: 0,
            papeleria: 0,
            servicios: 0,
          ),
        );

  void setGastos(double alquiler, double depreciacion, double gVentas,
      double nomina, double papeleria, double servicios) async {
    final db = await _getDatabase();

    db.insert('user_expenses', {
      'id': 1,
      'alquiler': alquiler,
      'depreciacion': depreciacion,
      'gventas': gVentas,
      'nomina': nomina,
      'papeleria': papeleria,
      'servicios': servicios,
      'total': calcularTotalGastos()
    });
  }

  Future<void> loadExpenses() async {
    final db = await _getDatabase();
    final data = await db.query('user_expenses');
    final expenses = data
        .map(
          (row) => GastosAdministrativos(
              alquiler: row['alquiler'] as double,
              depreciacion: row['depreciacion'] as double,
              gVentas: row['gVentas'] as double,
              nomina: row['nomina'] as double,
              papeleria: row['papeleria'] as double,
              servicios: row['servicios'] as double,
              total: row['total'] as double),
        )
        .toList();

    state = expenses[0];
  }

  double calcularTotalGastos() {
    double total = state.alquiler +
        state.depreciacion +
        state.gVentas +
        state.nomina +
        state.papeleria +
        state.servicios;
    return total;
  }
}

final gastosProvider =
    StateNotifierProvider<GastosNotifier, GastosAdministrativos>(
  (ref) => GastosNotifier(),
);
