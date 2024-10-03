import 'package:app/models/ingrediente.dart';
import 'package:flutter/material.dart';

class IngredientInfo extends StatelessWidget {
  const IngredientInfo({
    super.key,
    required this.ingrediente,
  });

  final Ingrediente ingrediente;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 25),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            ingrediente.nombre,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 18,
            ),
          ),
          Container(
            width: 100,
            padding: const EdgeInsets.all(8),
            child: Text(
              '\$ ${ingrediente.costo.toString()}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
