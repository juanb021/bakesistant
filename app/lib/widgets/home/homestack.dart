import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:app/widgets/boton.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/screens/expenses_screen.dart';

class Homestack extends StatefulWidget {
  const Homestack({super.key});

  @override
  State<Homestack> createState() => _HomestackState();
}

class _HomestackState extends State<Homestack> {
  String? userName;

  @override
  void initState() {
    super.initState();
    // Obtén el nombre del usuario en el initState
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      userName = user?.email ?? "Usuario"; // Nombre o "Usuario" por defecto
    });
  }

  void openExpenses() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const ExpensesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Boton(
            onTap: () {},
            texto: 'Configuracion',
          ),
          const SizedBox(height: 20),
          Boton(onTap: openExpenses, texto: 'Configurar Gastos'),
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: () {
              AuthService authService = AuthService();
              authService.logout();
            },
            label: Text(
              'Cerrar Sesion',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.secondary,
            ),
          )
        ],
      ),
    );
  }
}
