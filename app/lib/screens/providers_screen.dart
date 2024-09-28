import 'package:app/widgets/providers_screen/provider_card.dart';
import 'package:flutter/material.dart';

import 'package:app/models/proveedor.dart';
import 'package:app/data/datos_proveedores.dart';

const List<Proveedor> proveedores = proveedoresDisponibles;

class ProvidersScreen extends StatelessWidget {
  const ProvidersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 12),
      child: ListView.builder(
        itemCount: proveedores.length,
        itemBuilder: (context, index) =>
            ProviderCard(proveedor: proveedores[index]),
      ),
    );
  }
}
