import 'package:app/models/ingredient.dart';
import 'package:app/providers/ingredients_provider.dart';
import 'package:app/widgets/boton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IngredientForm extends ConsumerStatefulWidget {
  final Ingredient? ingrediente;

  const IngredientForm({
    super.key,
    this.ingrediente,
  });

  @override
  ConsumerState<IngredientForm> createState() {
    return _IngredientFormState();
  }
}

class _IngredientFormState extends ConsumerState<IngredientForm> {
  final form = GlobalKey<FormState>();
  late String nombre;
  late double costo;

  @override
  void initState() {
    super.initState();
    nombre = widget.ingrediente?.name ?? '';
    costo = widget.ingrediente?.cost ?? 0;
  }

  void submit() {
    if (!form.currentState!.validate()) {
      return;
    }

    form.currentState!.save();

    // Si el ingrediente existe, actualiza; si no, crea uno nuevo
    if (widget.ingrediente != null) {
      ref
          .read(ingredientsProvider.notifier)
          .updateIngredient(widget.ingrediente!.name, nombre, costo);
    } else {
      ref.read(ingredientsProvider.notifier).addIngredient(nombre, costo);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            widget.ingrediente == null
                ? 'Agrega un Ingrediente'
                : 'Edita el Ingrediente',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onTertiaryContainer,
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
                    labelText: 'Ingrediente',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa un ingrediente válido';
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
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
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
                  texto: widget.ingrediente == null
                      ? 'Agregar Ingrediente'
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
