import 'package:app/models/receta.dart';
import 'package:app/providers/recetas_provider.dart';
import 'package:app/screens/receta_detalles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecetaCard extends ConsumerStatefulWidget {
  const RecetaCard({
    super.key,
    required this.receta,
  });

  final Receta receta;

  @override
  ConsumerState<RecetaCard> createState() {
    return _RecetaCardState();
  }
}

class _RecetaCardState extends ConsumerState<RecetaCard> {
  void _openDetails() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => RecetaDetalles(receta: widget.receta)));
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.receta.nombre),
      onDismissed: (direction) {
        ref.read(recetasProvider.notifier).deleteReceta(widget.receta.nombre);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Receta eliminada!',
            ),
          ),
        );
      },
      child: InkWell(
        onTap: _openDetails,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 25),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.receta.nombre,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
