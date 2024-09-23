class GastosAdministrativos {
  GastosAdministrativos({
    required this.alquiler,
    required this.depreciacion,
    required this.gVentas,
    required this.nomina,
    required this.papeleria,
    required this.servicios,
    double? total,
  }) : total = total ?? 0;

  final double nomina;
  final double depreciacion;
  final double alquiler;
  final double gVentas;
  final double papeleria;
  final double servicios;
  final double total;
}
