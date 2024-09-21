class Ingrediente {
  const Ingrediente({
    required this.nombre,
    required this.costo,
    this.cantidad,
  });

  final String nombre;
  final double costo;
  final double? cantidad;
}
