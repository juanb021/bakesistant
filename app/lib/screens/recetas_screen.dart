import 'package:app/models/receta.dart';
import 'package:app/providers/recetas_provider.dart';
import 'package:app/widgets/new_receta_form.dart';
import 'package:app/widgets/recipes/receta_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecetasScreen extends ConsumerStatefulWidget {
  const RecetasScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _RecetasScreenState();
  }
}

class _RecetasScreenState extends ConsumerState<RecetasScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      ref.read(recetasProvider.notifier).filterRecetasByName(query);
    } else {
      ref.read(recetasProvider.notifier).resetRecetas();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addReceta() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => const NewRecetaForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Receta> recetas = ref.watch(recetasProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryFixed,
          title: Text(
            'Tus Recetas',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          actions: [
            IconButton(
              onPressed: _addReceta,
              icon: const Icon(
                Icons.add,
                size: 34,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Buscar Receta...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
            Expanded(
              child: recetas.isNotEmpty
                  ? ListView.builder(
                      itemCount: recetas.length,
                      itemBuilder: (ctx, index) {
                        return RecetaCard(receta: recetas[index]);
                      },
                    )
                  : const Center(
                      child: Text(
                        '¡Ninguna Receta!',
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
