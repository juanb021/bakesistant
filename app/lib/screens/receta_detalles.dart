import 'package:app/models/receta.dart';
import 'package:app/providers/gastos_operativos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecetaDetalles extends ConsumerStatefulWidget {
  const RecetaDetalles({
    super.key,
    required this.receta,
  });

  final Receta receta;

  @override
  ConsumerState<RecetaDetalles> createState() {
    return _RecetaDetallesState();
  }
}

class _RecetaDetallesState extends ConsumerState<RecetaDetalles> {
  int cantidad = 1;
  int cantidadEmpaques = 1;
  double porcentajeGanancia = 0.0;
  double totalConGanancia = 0.0;
  double totalCostoMateriales = 0.0;
  double totalCostoEmpaques = 0.0;

  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _packagingController = TextEditingController();
  final TextEditingController _percentController = TextEditingController();

  void _onQuantityChange(int input) {
    setState(() {
      cantidad = input > 0 ? input : 1;

      // Calcula el costo total de materiales
      totalCostoMateriales =
          widget.receta.ingredientList.fold(0.0, (sum, ingredienteMap) {
        final ingrediente = ingredienteMap.keys.first;
        final cantidadIngrediente = ingredienteMap.values.first;
        final costoIngrediente = ingrediente.costo / 1000;

        // Calcula el costo total del ingrediente considerando la cantidad
        return sum + (costoIngrediente * cantidadIngrediente * cantidad);
      });
    });
  }

  void _onPackageChange(int input) {
    setState(() {
      cantidadEmpaques = input > 0 ? input : 1;

      // Calcula el costo total de empaques
      totalCostoEmpaques =
          widget.receta.packageList.fold(0.0, (sum, empaqueMap) {
        final empaque = empaqueMap.keys.first;
        final cantidadEmpaque = empaqueMap.values.first;
        final costoEmpaque = empaque.costo;

        // Calcula el costo total del empaque considerando la cantidad de empaques
        return sum + (costoEmpaque * cantidadEmpaque * cantidadEmpaques);
      });
    });
  }

  void _onPercentChanged(double porcentaje) {
    setState(() {
      porcentajeGanancia = porcentaje;
    });
  }

  double _calcularCostoTotal(
      double gastosOperativos, double monthlyProduction) {
    double costoFijoPorUnidad = gastosOperativos / monthlyProduction;
    return totalCostoMateriales + totalCostoEmpaques + costoFijoPorUnidad;
  }

  @override
  Widget build(BuildContext context) {
    final double gastosOperativos =
        ref.read(gastosProvider.notifier).calcularTotalGastos();
    final Receta receta = widget.receta;
    final String costoTotal =
        _calcularCostoTotal(gastosOperativos, receta.monthlyProduction)
            .toStringAsFixed(2);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryFixed,
        title: Text(
          receta.nombre,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navega a NewRecetaForm para editar la receta
            },
            icon: const Icon(
              Icons.edit_note,
              size: 34,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: 'Cantidad de unidades',
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        prefixIcon: Icon(
                          Icons.bakery_dining_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 34,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final int? input = int.tryParse(value);
                        if (input != null) {
                          _onQuantityChange(input);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _packagingController,
                      decoration: InputDecoration(
                        labelText: 'Cantidad de empaques',
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        prefixIcon: Icon(
                          Icons.shopping_bag,
                          color: Theme.of(context).colorScheme.primary,
                          size: 34,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final int? input = int.tryParse(value);
                        if (input != null) {
                          _onPackageChange(input);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Ingrediente',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      'Cantidad',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Costo',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            for (final ingredienteMap in receta.ingredientList)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        ingredienteMap.keys.first.nombre,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        (ingredienteMap.values.first * cantidad)
                            .toStringAsFixed(0),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        ((ingredienteMap.keys.first.costo / 1000) *
                                (ingredienteMap.values.first * cantidad))
                            .toStringAsFixed(3),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Costo de materiales',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      totalCostoMateriales.toStringAsFixed(3),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Nueva sección de empaques
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Empaque',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      'Cantidad',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Costo',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            for (final empaqueMap in receta.packageList)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        empaqueMap.keys.first.nombre,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        (empaqueMap.values.first * cantidadEmpaques)
                            .toStringAsFixed(0),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        (empaqueMap.keys.first.costo * cantidadEmpaques)
                            .toStringAsFixed(3),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Costo fijo por unidad',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      (gastosOperativos / receta.monthlyProduction)
                          .toStringAsFixed(2),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Costo Total',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      costoTotal.toString(),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _percentController,
                decoration: InputDecoration(
                  labelText: 'Porcentaje de Ganancia',
                  prefixIcon: const Icon(Icons.percent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final double? input = double.tryParse(value);
                  if (input != null) {
                    _onPercentChanged(input);
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Precio de venta: \$${(double.parse(costoTotal) * (1 + porcentajeGanancia / 100)).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
