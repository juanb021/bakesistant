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
      child: Boton(
        onTap: openExpenses,
        texto: 'Configurar Gastos',
      ),
    );
  }
}
