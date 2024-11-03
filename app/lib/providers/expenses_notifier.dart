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
        'rent': rent,
        'depreciation': depreciation,
        'sales_expense': salesExpense,
        'payroll': payroll,
        'stationery': stationery,
        'utilities': utilities,
        'total': calculateTotalExpenses()
      },
      where: 'id = ?',
      whereArgs: [1],
    );

    loadExpenses();
  }

  // Method to load expenses from the database or initialize defaults if empty
  Future<void> loadExpenses() async {
    final db = await getDatabase();
    final data = await db.query('user_expenses');
    if (data.isNotEmpty) {
      final expenses = data
          .map(
            (row) => AdministrativeExpenses(
                rent: row['rent'] as double,
                depreciation: row['depreciation'] as double,
                salesExpense: row['sales_expense'] as double,
                payroll: row['payroll'] as double,
                stationery: row['stationery'] as double,
                utilities: row['utilities'] as double,
                total: row['total'] as double),
          )
          .toList();

      state = expenses[0];
    } else {
      await db.insert(
        'user_expenses',
        {
          'rent': 0,
          'depreciation': 0,
          'sales_expense': 0,
          'payroll': 0,
          'stationery': 0,
          'utilities': 0,
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
