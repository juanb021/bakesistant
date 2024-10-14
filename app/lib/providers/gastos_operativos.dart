import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/database/database_helper.dart';
import 'package:app/models/gastos_administrativos.dart';

class GastosNotifier extends StateNotifier<GastosAdministrativos> {
  GastosNotifier()
      : super(GastosAdministrativos(
          alquiler: 0,
          depreciacion: 0,
          gVentas: 0,
          nomina: 0,
          papeleria: 0,
          servicios: 0,
        )) {
    loadExpenses();
  }

  void setGastos(double alquiler, double depreciacion, double gVentas,
      double nomina, double papeleria, double servicios) async {
    final db = await getDatabase();

    await db.update(
      'user_expenses',
      {
        'alquiler': alquiler,
        'depreciacion': depreciacion,
        'gventas': gVentas,
        'nomina': nomina,
        'papeleria': papeleria,
        'servicios': servicios,
        'total': calcularTotalGastos()
      },
      where: 'id = ?',
      whereArgs: [1],
    );

    loadExpenses();
  }

  Future<void> loadExpenses() async {
    final db = await getDatabase();
    final data = await db.query('user_expenses');
    if (data.isNotEmpty) {
      final expenses = data
          .map(
            (row) => GastosAdministrativos(
                alquiler: row['alquiler'] as double,
                depreciacion: row['depreciacion'] as double,
                gVentas: row['gventas'] as double,
                nomina: row['nomina'] as double,
                papeleria: row['papeleria'] as double,
                servicios: row['servicios'] as double,
                total: row['total'] as double),
          )
          .toList();

      state = expenses[0];
    } else {
      await db.insert(
        'user_expenses',
        {
          'alquiler': 0,
          'depreciacion': 0,
          'gventas': 0,
          'nomina': 0,
          'papeleria': 0,
          'servicios': 0,
          'total': calcularTotalGastos()
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    }
  }

  double calcularTotalGastos() {
    return state.alquiler +
        state.depreciacion +
        state.gVentas +
        state.nomina +
        state.papeleria +
        state.servicios;
  }
}

final gastosProvider =
    StateNotifierProvider<GastosNotifier, GastosAdministrativos>(
  (ref) => GastosNotifier(),
);
