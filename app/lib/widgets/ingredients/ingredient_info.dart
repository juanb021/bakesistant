import 'package:app/models/ingrediente.dart';
import 'package:app/providers/ingredients_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IngredientInfo extends ConsumerStatefulWidget {
  const IngredientInfo({
    super.key,
    required this.ingrediente,
  });

  final Ingrediente ingrediente;

  @override
  ConsumerState<IngredientInfo> createState() => _IngredientInfoState();
}

class _IngredientInfoState extends ConsumerState<IngredientInfo> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.ingrediente.nombre),
      onDismissed: (direction) {
        ref
            .watch(ingredientesProvider.notifier)
            .deleteIngredient(widget.ingrediente.nombre);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Ingrediente eliminado!',
            ),
          ),
        );
      },
      child: InkWell(
        onTap: () {},
        child: Container(
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
                widget.ingrediente.nombre,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
                ),
              ),
              Container(
                width: 100,
                padding: const EdgeInsets.all(8),
                child: Text(
                  '\$ ${widget.ingrediente.costo.toString()}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
