class Proveedor {
  const Proveedor({
    required this.categoria,
    required this.correo,
    required this.nombre,
    required this.telefono,
    required this.direccion,
    required this.zona,
  });

  final String nombre;
  final String telefono;
  final String categoria;
  final String direccion;
  final String correo;
  final String zona;
}
