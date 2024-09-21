import 'package:app/models/gastos_administrativos.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GastosNotifier extends StateNotifier<GastosAdministrativos> {
  GastosNotifier()
      : super(
          const GastosAdministrativos(
            alquiler: 0,
            depreciacion: 0,
            gVentas: 0,
            nomina: 0,
            papeleria: 0,
            servicios: 0,
            impuestos: 0,
          ),
        );
}

final gastosProvider =
    StateNotifierProvider<GastosNotifier, GastosAdministrativos>(
  (ref) => GastosNotifier(),
);
