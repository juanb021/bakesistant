import 'package:app/models/ingrediente.dart';

class Receta {
  Receta({
    required this.nombre,
    required this.ingredientes,
    this.costoMaterial,
  });

  final String nombre;
  final List<Ingrediente> ingredientes;
  double? costoMaterial;

  void getCosto() {
    double costoTotal = 0;

    for (var ingrediente in ingredientes) {
      if (ingrediente.cantidad != null) {
        costoTotal += ingrediente.cantidad! * ingrediente.costo;
      }
    }
    costoMaterial = costoTotal;
  }
}
