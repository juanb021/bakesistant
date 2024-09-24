import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/widgets/boton.dart';
import 'package:app/models/gastos_administrativos.dart';
import 'package:app/providers/gastos_operativos.dart';

class ExpenseForm extends ConsumerWidget {
  const ExpenseForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = GlobalKey<FormState>();
    GastosAdministrativos gastos = ref.watch(gastosProvider);
    double alquiler = 0;
    double depreciacion = 0;
    double gVentas = 0;
    double nomina = 0;
    double papeleria = 0;
    double servicios = 0;

    debugPrint('alquiler: ${gastos.alquiler}');

    void submit() {
      if (!form.currentState!.validate()) {
        return;
      }

      form.currentState!.save();

      ref.read(gastosProvider.notifier).setGastos(
          alquiler, depreciacion, gVentas, nomina, papeleria, servicios);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos actualizados correctamente')));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          padding: const EdgeInsets.all(7),
          child: Form(
            key: form,
            child: Column(
              children: [
                TextFormField(
                  initialValue: gastos.alquiler.toString(),
                  decoration: InputDecoration(
                    labelText: 'Alquiler',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce un valor numérico.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, introduce un valor numérico.';
                    }
                    double parsedValue = double.tryParse(value)!;
                    if (parsedValue < 0) {
                      return 'El valor debe ser mayor o igual a 0.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    alquiler = double.parse(value!);
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: gastos.depreciacion.toString(),
                  decoration: InputDecoration(
                    labelText: 'Depreciacion',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce un valor numérico.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, introduce un valor numérico.';
                    }
                    double parsedValue = double.tryParse(value)!;
                    if (parsedValue < 0) {
                      return 'El valor debe ser mayor o igual a 0.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    depreciacion = double.parse(value!);
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: gastos.gVentas.toString(),
                  decoration: InputDecoration(
                    labelText: 'Gastos de ventas',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce un valor numérico.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, introduce un valor numérico.';
                    }
                    double parsedValue = double.tryParse(value)!;
                    if (parsedValue < 0) {
                      return 'El valor debe ser mayor o igual a 0.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    gVentas = double.parse(value!);
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: gastos.nomina.toString(),
                  decoration: InputDecoration(
                    labelText: 'Nomina',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce un valor numérico.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, introduce un valor numérico.';
                    }
                    double parsedValue = double.tryParse(value)!;
                    if (parsedValue < 0) {
                      return 'El valor debe ser mayor o igual a 0.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    nomina = double.parse(value!);
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: gastos.papeleria.toString(),
                  decoration: InputDecoration(
                    labelText: 'Papeleria',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce un valor numérico.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, introduce un valor numérico.';
                    }
                    double parsedValue = double.tryParse(value)!;
                    if (parsedValue < 0) {
                      return 'El valor debe ser mayor o igual a 0.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    papeleria = double.parse(value!);
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: gastos.servicios.toString(),
                  decoration: InputDecoration(
                    labelText: 'Servicios',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce un valor numérico.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, introduce un valor numérico.';
                    }
                    double parsedValue = double.tryParse(value)!;
                    if (parsedValue < 0) {
                      return 'El valor debe ser mayor o igual a 0.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    servicios = double.parse(value!);
                  },
                ),
              ],
            ),
          ),
        ),
        Boton(onTap: submit, texto: 'Actualizar informacion'),
      ],
    );
  }
}
