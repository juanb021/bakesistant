import 'package:app/widgets/expenses_screen/expense_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
          title: const Text('Configura tus gastos'),
        ),
        body: const SingleChildScrollView(child: ExpenseForm()));
  }
}
