import 'package:app/providers/gastos_operativos.dart';
import 'package:app/widgets/expenses_screen/expense_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() {
    return _ExpensesScreenstate();
  }
}

class _ExpensesScreenstate extends ConsumerState<ExpensesScreen> {
  late Future<void> _expensesFuture;

  @override
  void initState() {
    super.initState();
    _expensesFuture = ref.read(gastosProvider.notifier).loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryFixed,
        title: const Text('Configura tus gastos'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _expensesFuture,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const CircularProgressIndicator()
                  : const ExpenseForm(),
        ),
      ),
    );
  }
}
