import 'package:app/models/ingrediente.dart';

class Receta {
  Receta({
    required this.nombre,
    required this.ingredientList,
    this.costoMaterial,
  });

  final String nombre;
  // En este caso el double es la cantidad del ingrediente
  final List<Map<Ingrediente, double>> ingredientList;
  double? costoMaterial;

  double getCosto() {
    double costoTotal = 0;

    for (final ingredientMap in ingredientList) {
      final ingrediente = ingredientMap.keys.first;
      final cantidad = ingredientMap[ingrediente] ?? 0;

      costoTotal += ingrediente.costo * cantidad;
    }

    costoMaterial = costoTotal;

    return costoMaterial!;
  }
}
