import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/screens/guides_screen.dart';
import 'package:app/widgets/expenses_screen/expense_form.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() {
    return _ExpensesScreenstate();
  }
}

class _ExpensesScreenstate extends ConsumerState<ExpensesScreen> {
  void openHelp() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const GuidesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryFixed,
        title: const Text('Configura tus gastos'),
        actions: [
          IconButton(
            onPressed: openHelp,
            icon: Icon(
              Icons.help_outline,
              size: 34,
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        ],
      ),
      body: const SingleChildScrollView(child: ExpenseForm()),
    );
  }
}
