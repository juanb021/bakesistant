import 'package:app/providers/recetas_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/models/receta.dart';
import 'package:app/models/ingrediente.dart';
import 'package:app/models/empaque.dart';
import 'package:app/providers/ingredients_provider.dart';
import 'package:app/providers/empaques_provider.dart';

class NewRecetaForm extends ConsumerStatefulWidget {
  final Receta? receta;

  const NewRecetaForm({
    super.key,
    this.receta,
  });

  @override
  ConsumerState<NewRecetaForm> createState() {
    return _NewRecetaFormState();
  }
}

class _NewRecetaFormState extends ConsumerState<NewRecetaForm> {
  final form = GlobalKey<FormState>();
  late String nombre;
  late List<Map<Ingrediente, double>> ingredientList;
  late List<Map<Empaque, double>> packageList;
  late double monthlyProduction;

  @override
  void initState() {
    super.initState();
    nombre = widget.receta?.nombre ?? '';
    ingredientList = widget.receta?.ingredientList ?? [];
    packageList = widget.receta?.packageList ?? [];
    monthlyProduction = widget.receta?.monthlyProduction ?? 0;

    // Inicializar _ingredientesConCantidad y _empaquesConCantidad con los valores de ingredientList y packageList
    _ingredientesConCantidad.clear();
    for (var ingrediente in ingredientList) {
      ingrediente.forEach((key, value) {
        _ingredientesConCantidad.add({"ingrediente": key, "cantidad": value});
      });
    }

    _empaquesConCantidad.clear();
    for (var empaque in packageList) {
      empaque.forEach((key, value) {
        _empaquesConCantidad.add({"empaque": key, "cantidad": value});
      });
    }
  }

  final List<Map<String, dynamic>> _ingredientesConCantidad = [
    {"ingrediente": null, "cantidad": null}
  ];

  final List<Map<String, dynamic>> _empaquesConCantidad = [
    {"empaque": null, "cantidad": null}
  ];

  List<Ingrediente> _getIngredientesDisponibles(
      int index, List<Ingrediente> listaIngredientes) {
    final Set<dynamic> ingredientesSeleccionados = _ingredientesConCantidad
        .asMap()
        .entries
        .where((entry) => entry.key != index)
        .map((entry) => entry.value["ingrediente"])
        .toSet();

    return listaIngredientes
        .where(
            (ingrediente) => !ingredientesSeleccionados.contains(ingrediente))
        .toSet()
        .toList();
  }

  List<Empaque> _getEmpaquesDisponibles(
      int index, List<Empaque> listaEmpaques) {
    final Set<dynamic> empaquesSeleccionados = _empaquesConCantidad
        .asMap()
        .entries
        .where((entry) => entry.key != index)
        .map((entry) => entry.value["empaque"])
        .toSet();

    return listaEmpaques
        .where((empaque) => !empaquesSeleccionados.contains(empaque))
        .toSet()
        .toList();
  }

  void submit() {
    if (!form.currentState!.validate()) {
      return;
    }

    form.currentState!.save();

    ingredientList.clear();
    for (var ingredienteConCantidad in _ingredientesConCantidad) {
      Ingrediente? ingrediente = ingredienteConCantidad['ingrediente'];
      double? cantidad = ingredienteConCantidad['cantidad'];

      if (ingrediente != null && cantidad != null) {
        ingredientList.add({ingrediente: cantidad});
      }
    }

    packageList.clear();
    for (var empaqueConCantidad in _empaquesConCantidad) {
      Empaque? empaque = empaqueConCantidad['empaque'];
      double? cantidad = empaqueConCantidad['cantidad'];

      if (empaque != null && cantidad != null) {
        packageList.add({empaque: cantidad});
      }
    }

    ref
        .read(recetasProvider.notifier)
        .addReceta(nombre, ingredientList, packageList, monthlyProduction);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final List<Ingrediente> listaIngredientes = ref.watch(ingredientesProvider);
    final List<Empaque> listaEmpaques = ref.watch(empaquesProvider);

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
                  Row(
                    children: [
                      Text(
                        'Nombre de la receta',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      nombre = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa un nombre para tu receta';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Ingredientes de la receta',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ..._ingredientesConCantidad.asMap().entries.map((entry) {
                    int index = entry.key;
                    var ingredienteConCantidad = entry.value;

                    List<Ingrediente> ingredientesDisponibles =
                        _getIngredientesDisponibles(index, listaIngredientes);

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<Ingrediente>(
                                value: ingredienteConCantidad["ingrediente"],
                                items: ingredientesDisponibles
                                    .map((Ingrediente ingrediente) {
                                  return DropdownMenuItem<Ingrediente>(
                                    value: ingrediente,
                                    child: Text(ingrediente.nombre),
                                  );
                                }).toList(),
                                onChanged: (Ingrediente? newValue) {
                                  setState(() {
                                    _ingredientesConCantidad[index]
                                        ["ingrediente"] = newValue;
                                  });
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Ingrediente',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Selecciona un ingrediente';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Cantidad',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _ingredientesConCantidad[index]
                                        ["cantidad"] = double.tryParse(value);
                                  });
                                },
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      double.tryParse(value)! < 1 ||
                                      double.tryParse(value) == null) {
                                    return 'Ingresa una cantidad válida';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                      ],
                    );
                  }),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _ingredientesConCantidad
                            .add({"ingrediente": null, "cantidad": null});
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar Ingrediente'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'Empaques de la receta',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ..._empaquesConCantidad.asMap().entries.map((entry) {
                    int index = entry.key;
                    var empaqueConCantidad = entry.value;

                    List<Empaque> empaquesDisponibles =
                        _getEmpaquesDisponibles(index, listaEmpaques);

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<Empaque>(
                                value: empaqueConCantidad["empaque"],
                                items:
                                    empaquesDisponibles.map((Empaque empaque) {
                                  return DropdownMenuItem<Empaque>(
                                    value: empaque,
                                    child: Text(empaque.nombre),
                                  );
                                }).toList(),
                                onChanged: (Empaque? newValue) {
                                  setState(() {
                                    _empaquesConCantidad[index]["empaque"] =
                                        newValue;
                                  });
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Empaque',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Selecciona un empaque';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Cantidad',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _empaquesConCantidad[index]["cantidad"] =
                                        double.tryParse(value);
                                  });
                                },
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      double.tryParse(value)! < 1 ||
                                      double.tryParse(value) == null) {
                                    return 'Ingresa una cantidad válida';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
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
                  Row(
                    children: [
                      Text(
                        'Produccion Mensual',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: submit,
                        child: const Text('Guardar Receta'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancelar'))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
