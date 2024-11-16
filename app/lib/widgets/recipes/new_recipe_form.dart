import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/utils/utils.dart';
import 'package:app/models/recipe.dart';
import 'package:app/models/package.dart';
import 'package:app/models/ingredient.dart';
import 'package:app/widgets/recipes/titulo.dart';
import 'package:app/providers/recipes_provider.dart';
import 'package:app/widgets/recipes/package_row.dart';
import 'package:app/providers/packages_provider.dart';
import 'package:app/widgets/recipes/ingredient_row.dart';
import 'package:app/providers/ingredients_provider.dart';
import 'package:app/widgets/recipes/form_controller.dart';
import 'package:app/widgets/recipes/recipe_name_field.dart';

class NewRecipeForm extends ConsumerStatefulWidget {
  final Recipe? receta;

  const NewRecipeForm({
    super.key,
    this.receta,
  });

  @override
  ConsumerState<NewRecipeForm> createState() {
    return _NewRecetaFormState();
  }
}

class _NewRecetaFormState extends ConsumerState<NewRecipeForm> {
  final form = GlobalKey<FormState>();
  late String nombre;
  late double monthlyProduction;
  late List<Map<Package, double>> packageList;
  late List<Map<Ingredient, double>> ingredientList;
  late List<Map<String, dynamic>> _ingredientesConCantidad;
  late List<Map<String, dynamic>> _empaquesConCantidad;

  @override
  void initState() {
    super.initState();
    nombre = widget.receta?.name ?? '';
    ingredientList = widget.receta?.ingredientList ?? [];
    packageList = widget.receta?.packageList ?? [];
    monthlyProduction = widget.receta?.monthlyProduction ?? 0;

    // Inicializar _ingredientesConCantidad y _empaquesConCantidad con los valores de ingredientList y packageList
    _ingredientesConCantidad = [];
    for (var ingrediente in ingredientList) {
      ingrediente.forEach((key, value) {
        _ingredientesConCantidad.add({"ingrediente": key, "cantidad": value});
      });
    }
    if (_ingredientesConCantidad.isEmpty) {
      _ingredientesConCantidad.add({"ingrediente": null, "cantidad": null});
    }

    _empaquesConCantidad = [];
    for (var empaque in packageList) {
      empaque.forEach((key, value) {
        _empaquesConCantidad.add({"empaque": key, "cantidad": value});
      });
    }
    if (_empaquesConCantidad.isEmpty) {
      _empaquesConCantidad.add({"empaque": null, "cantidad": null});
    }
  }

  void submit() {
    if (!form.currentState!.validate()) {
      return;
    }

    form.currentState!.save();

    ingredientList.clear();
    for (var ingredienteConCantidad in _ingredientesConCantidad) {
      Ingredient? ingrediente = ingredienteConCantidad['ingrediente'];
      double? cantidad = ingredienteConCantidad['cantidad'];

      if (ingrediente != null && cantidad != null) {
        ingredientList.add({ingrediente: cantidad});
      }
    }

    packageList.clear();
    for (var empaqueConCantidad in _empaquesConCantidad) {
      Package? empaque = empaqueConCantidad['empaque'];
      double? cantidad = empaqueConCantidad['cantidad'];

      if (empaque != null && cantidad != null) {
        packageList.add({empaque: cantidad});
      }
    }

    // Crear o actualizar la receta
    Recipe updatedRecipe = Recipe(
      id: widget.receta?.id, // Usar el id si existe
      name: nombre,
      ingredientList: ingredientList,
      packageList: packageList,
      monthlyProduction: monthlyProduction,
    );

    if (widget.receta != null) {
      // Actualizar la receta existente
      ref.read(recipesProvider.notifier).updateRecipe(updatedRecipe);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Receta Actualizada!',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.primaryFixedDim,
            ),
          ),
        ),
      );
      Navigator.of(context).pop();
    } else {
      // Agregar una nueva receta
      ref
          .read(recipesProvider.notifier)
          .addRecipe(nombre, ingredientList, packageList, monthlyProduction);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Ingredient> listaIngredientes = ref.watch(ingredientsProvider);
    final List<Package> listaEmpaques = ref.watch(packagesProvider);
    final Recipe? recipe = widget.receta;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: form,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const Titulo(titulo: 'Nombre de la Receta'),
                  const SizedBox(height: 10),
                  RecipeNameField(
                    onSaved: (value) {
                      nombre = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa un nombre para tu Receta';
                      }
                      return null;
                    },
                    recipe: recipe?.name,
                  ),
                  const SizedBox(height: 10),
                  const Titulo(titulo: 'Ingredientes de la Receta'),
                  const SizedBox(height: 10),
                  ..._ingredientesConCantidad.asMap().entries.map((entry) {
                    int index = entry.key;
                    var ingredienteConCantidad = entry.value;

                    // Get the avaiable ingredients using utils.dart
                    List<Ingredient> ingredientesDisponibles =
                        getAvaiableIngredients(
                            index, listaIngredientes, _ingredientesConCantidad);

                    return Column(
                      children: [
                        Dismissible(
                          key: ValueKey(index),
                          onDismissed: (direction) {
                            Future.delayed(Duration.zero, () {
                              if (index < _ingredientesConCantidad.length) {
                                setState(() {
                                  _ingredientesConCantidad.removeAt(index);
                                });
                              }
                            });
                          },
                          child: IngredientRow(
                            avaiableIngredients: ingredientesDisponibles,
                            ingredient: ingredienteConCantidad,
                            index: index,
                            ingredientQuanityList: _ingredientesConCantidad,
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    );
                  }),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Future.delayed(Duration.zero, () {
                        setState(() {
                          _ingredientesConCantidad
                              .add({"ingrediente": null, "cantidad": null});
                        });
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar Ingrediente'),
                  ),
                  const SizedBox(height: 20),
                  const Titulo(titulo: 'Empaques de la receta'),
                  const SizedBox(height: 10),
                  ..._empaquesConCantidad.asMap().entries.map((entry) {
                    int index = entry.key;
                    var empaqueConCantidad = entry.value;

                    List<Package> empaquesDisponibles = getAvaiablePackages(
                        index, listaEmpaques, _empaquesConCantidad);

                    return Column(
                      children: [
                        Dismissible(
                          key: ValueKey(index),
                          onDismissed: (direction) {
                            setState(() {
                              _empaquesConCantidad.removeAt(index);
                            });
                          },
                          child: PackageRow(
                            avaiablePackages: empaquesDisponibles,
                            package: empaqueConCantidad,
                            index: index,
                            packageQuanityList: _empaquesConCantidad,
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    );
                  }),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _empaquesConCantidad
                            .add({"empaque": null, "cantidad": null});
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar Empaque'),
                  ),
                  const SizedBox(height: 20),
                  const Titulo(titulo: 'Produccion Mensual'),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: recipe?.monthlyProduction.toStringAsFixed(0),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      monthlyProduction = double.tryParse(value) ?? 0;
                    },
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value)! < 1 ||
                          int.tryParse(value) == null) {
                        return 'Ingresa una cantidad válida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  FormController(onFormSave: submit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
