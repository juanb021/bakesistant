import 'package:app/models/package.dart';
import 'package:flutter/material.dart';

class PackageRow extends StatefulWidget {
  const PackageRow({
    super.key,
    required this.avaiablePackages,
    required this.package,
    required this.index,
    required this.packageQuanityList,
  });

  final int index;
  final List<Package> avaiablePackages;
  final Map<String, dynamic> package;
  final List<Map<String, dynamic>> packageQuanityList;

  @override
  State<PackageRow> createState() {
    return _PackageRowState();
  }
}

class _PackageRowState extends State<PackageRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<Package>(
            value: widget.package['empaque'],
            items: widget.avaiablePackages.map((Package paquete) {
              return DropdownMenuItem<Package>(
                value: paquete,
                child: Text(paquete.name),
              );
            }).toList(),
            onChanged: (Package? newValue) {
              setState(() {
                widget.packageQuanityList[widget.index]["empaque"] = newValue;
              });
            },
            decoration: const InputDecoration(
              labelText: 'empaque',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null) {
                return 'Selecciona un empaque';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: TextFormField(
            initialValue: widget.package["cantidad"]?.toString() ?? '',
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Cantidad',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                widget.packageQuanityList[widget.index]["cantidad"] =
                    double.tryParse(value);
              });
            },
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  double.tryParse(value)! < 1 ||
                  double.tryParse(value) == null) {
                return 'Ingresa una cantidad válida';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
