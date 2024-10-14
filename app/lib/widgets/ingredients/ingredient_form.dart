import 'package:app/providers/ingredients_provider.dart';
import 'package:app/widgets/boton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IngredientForm extends ConsumerStatefulWidget {
  const IngredientForm({
    super.key,
  });

  @override
  ConsumerState<IngredientForm> createState() {
    return _IngredientFormState();
  }
}

class _IngredientFormState extends ConsumerState<IngredientForm> {
  final form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String nombre = '';
    double costo = 0;

    void submit() {
      if (!form.currentState!.validate()) {
        return;
      }

      form.currentState!.save();

      ref.read(ingredientesProvider.notifier).addIngredient(nombre, costo);

      Navigator.of(context).pop();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Agrega un Ingrediente',
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
                  decoration: InputDecoration(
                    labelText: 'Ingrediente',
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
                      return 'Por favor, ingresa un ingrediente válido';
                    }
                    return null; // Si no hay errores, retorna null
                  },
                  onSaved: (value) {
                    nombre = value!;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
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
                    return null; // Si no hay errores, retorna null
                  },
                  onSaved: (value) {
                    costo = double.tryParse(value!)!;
                  },
                ),
                const SizedBox(height: 30),
                Boton(onTap: submit, texto: 'Agregar Ingrediente')
              ],
            ),
          )
        ],
      ),
    );
  }
}
