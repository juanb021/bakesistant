import 'package:app/models/package.dart';
import 'package:app/providers/packages_notifier.dart';
import 'package:app/widgets/boton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmpaqueForm extends ConsumerStatefulWidget {
  final Package? empaque;

  const EmpaqueForm({
    super.key,
    this.empaque,
  });

  @override
  ConsumerState<EmpaqueForm> createState() {
    return _EmpaqueFormState();
  }
}

class _EmpaqueFormState extends ConsumerState<EmpaqueForm> {
  final form = GlobalKey<FormState>();
  late String nombre;
  late double costo;

  @override
  void initState() {
    super.initState();
    nombre = widget.empaque?.name ?? '';
    costo = widget.empaque?.cost ?? 0;
  }

  void submit() {
    if (!form.currentState!.validate()) {
      return;
    }

    form.currentState!.save();

    ref.read(packagesProvider.notifier).addPackage(nombre, costo);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Agrega un Empaque',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Form(
            key: form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: nombre,
                  decoration: InputDecoration(
                    labelText: 'Empaque',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa un empaque válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    nombre = value!;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: costo > 0 ? costo.toString() : '',
                  decoration: InputDecoration(
                    labelText: 'Costo',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa un valor';
                    }
                    final double? numericValue = double.tryParse(value);
                    if (numericValue == null || numericValue <= 0) {
                      return 'El costo debe ser un número mayor a 0';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    costo = double.tryParse(value!)!;
                  },
                ),
                const SizedBox(height: 30),
                Boton(
                  onTap: submit,
                  texto: nombre == ''
                      ? 'Agregar Empaque'
                      : 'Actualizar Información',
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
