import 'package:app/models/empaque.dart';
import 'package:app/models/ingrediente.dart';

class Receta {
  Receta({
    required this.nombre,
    required this.ingredientList,
    required this.packageList,
    required this.monthlyProduction,
    this.costoMaterial,
    this.precioVenta,
  });

  final String nombre;
  final List<Map<Ingrediente, double>> ingredientList;
  final List<Map<Empaque, double>> packageList;
  final double monthlyProduction;
  double? costoMaterial;
  double? precioVenta;

  double getCosto() {
    double costoTotal = 0;

    for (final ingredientMap in ingredientList) {
      final ingrediente = ingredientMap.keys.first;
      final cantidad = ingredientMap[ingrediente] ?? 0;

      costoTotal += ingrediente.costo * cantidad;
    }
    for (final packageMap in packageList) {
      final package = packageMap.keys.first;
      final cantidad = packageMap[package] ?? 0;

      costoTotal += package.costo * cantidad;
    }

    costoMaterial = costoTotal;

    return costoMaterial!;
  }
}
