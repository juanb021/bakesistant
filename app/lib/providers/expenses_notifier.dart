// Libraries
import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Modules
import 'package:app/database/database_helper.dart';
import 'package:app/models/administrative_expenses.dart';

class ExpensesNotifier extends StateNotifier<AdministrativeExpenses> {
  // Constructor initializes default expenses and loads saved expenses from database
  ExpensesNotifier()
      : super(AdministrativeExpenses(
          rent: 0,
          depreciation: 0,
          salesExpense: 0,
          payroll: 0,
          stationery: 0,
          utilities: 0,
        )) {
    loadExpenses();
  }

  // Method to set and save expenses to the database
  void setExpenses(double rent, double depreciation, double salesExpense,
      double payroll, double stationery, double utilities) async {
    final db = await getDatabase();

    await db.update(
      'user_expenses',
      {
        'alquiler': rent,
        'depreciacion': depreciation,
        'gventas': salesExpense,
        'nomina': payroll,
        'papeleria': stationery,
        'servicios': utilities,
        'total': calculateTotalExpenses()
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
            (row) => AdministrativeExpenses(
                rent: row['alquiler'] as double,
                depreciation: row['depreciacion'] as double,
                salesExpense: row['gventas'] as double,
                payroll: row['nomina'] as double,
                stationery: row['papeleria'] as double,
                utilities: row['servicios'] as double,
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
          'total': calculateTotalExpenses()
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    }
  }

  // Helper method to calculate the total of all expenses
  double calculateTotalExpenses() {
    return state.rent +
        state.depreciation +
        state.salesExpense +
        state.payroll +
        state.stationery +
        state.utilities;
  }
}

// Provider for managing the state of administrative expenses
final expensesProvider =
    StateNotifierProvider<ExpensesNotifier, AdministrativeExpenses>(
  (ref) => ExpensesNotifier(),
);
