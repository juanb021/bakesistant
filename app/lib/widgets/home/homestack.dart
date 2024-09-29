import 'package:app/widgets/home/login_form.dart';
import 'package:flutter/material.dart';

import 'package:app/widgets/boton.dart';
import 'package:app/screens/expenses_screen.dart';

class Homestack extends StatefulWidget {
  const Homestack({super.key});

  @override
  State<Homestack> createState() => _HomestackState();
}

class _HomestackState extends State<Homestack> {
  void openExpenses() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const ExpensesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          elevation: 16,
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Theme.of(context).colorScheme.primaryFixed,
              Theme.of(context).colorScheme.primaryFixedDim,
            ])),
            child: const LoginForm(),
          ),
        ),
        const SizedBox(height: 20),
        Boton(
          onTap: openExpenses,
          texto: 'Configurar Gastos',
        ),
      ],
    ));
  }
}
