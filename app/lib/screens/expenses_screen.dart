// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Modules
import 'package:app/screens/guides_screen.dart';
import 'package:app/widgets/expenses_screen/expense_form.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() {
    return _ExpensesScreenState();
  }
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  // Opens the help screen
  void openHelp() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const GuidesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text(
          'Configura tus gastos',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: openHelp,
            icon: const Icon(
              Icons.help_outline,
              size: 34,
              color: Colors.white,
            ),
          )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: const SingleChildScrollView(child: ExpenseForm()),
    );
  }
}
