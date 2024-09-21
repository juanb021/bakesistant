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
          ),
        );

  void setGastos(double alquiler, double depreciacion, double gVentas,
      double nomina, double papeleria, double servicios) {
    state = GastosAdministrativos(
      alquiler: alquiler,
      depreciacion: depreciacion,
      gVentas: gVentas,
      nomina: nomina,
      papeleria: papeleria,
      servicios: servicios,
    );
  }

  double calcularTotalGastos() {
    double total = state.alquiler +
        state.depreciacion +
        state.gVentas +
        state.nomina +
        state.papeleria +
        state.servicios;
    return total;
  }
}

final gastosProvider =
    StateNotifierProvider<GastosNotifier, GastosAdministrativos>(
  (ref) => GastosNotifier(),
);
