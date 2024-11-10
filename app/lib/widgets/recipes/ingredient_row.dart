import 'package:app/models/ingredient.dart';
import 'package:flutter/material.dart';

class IngredientRow extends StatefulWidget {
  const IngredientRow({
    super.key,
    required this.avaiableIngredients,
    required this.ingredient,
    required this.index,
    required this.ingredientQuanityList,
  });

  final int index;
  final List<Ingredient> avaiableIngredients;
  final Map<String, dynamic> ingredient;
  final List<Map<String, dynamic>> ingredientQuanityList;

  @override
  State<IngredientRow> createState() {
    return _IngredientRowState();
  }
}

class _IngredientRowState extends State<IngredientRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<Ingredient>(
            value: widget.ingredient["ingrediente"],
            items: widget.avaiableIngredients.map((Ingredient ingrediente) {
              return DropdownMenuItem<Ingredient>(
                value: ingrediente,
                child: Text(ingrediente.name),
              );
            }).toList(),
            onChanged: (Ingredient? newValue) {
              setState(() {
                widget.ingredientQuanityList[widget.index]["ingrediente"] =
                    newValue;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Ingrediente',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null) {
                return 'Selecciona un ingrediente';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: TextFormField(
            initialValue: widget.ingredient["cantidad"]?.toString() ?? '',
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Cantidad',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                widget.ingredientQuanityList[widget.index]["cantidad"] =
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
