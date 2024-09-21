class Proveedor {
  const Proveedor({
    required this.categoria,
    required this.correo,
    required this.nombre,
    required this.telefono,
    required this.zona,
  });

  final String nombre;
  final String telefono;
  final String categoria;
  final String zona;
  final String correo;
}
