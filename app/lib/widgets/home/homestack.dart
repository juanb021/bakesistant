import 'package:app/screens/guides_screen.dart';
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

  void openGuides() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const GuidesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Boton(
            onTap: openExpenses,
            texto: 'Configurar Gastos',
          ),
          const SizedBox(height: 32),
          Boton(
            onTap: openGuides,
            texto: 'Guias de uso',
          ),
        ],
      ),
    );
  }
}
