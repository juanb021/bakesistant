import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/models/empaque.dart';
import 'package:app/providers/empaques_provider.dart';
import 'package:app/widgets/empaque/empaque_info.dart';

class EmpaquesScreen extends ConsumerStatefulWidget {
  const EmpaquesScreen({super.key});

  @override
  ConsumerState<EmpaquesScreen> createState() {
    return _EmpaquesScreenState();
  }
}

class _EmpaquesScreenState extends ConsumerState<EmpaquesScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      ref.read(empaquesProvider.notifier).filterEmpaquesByName(query);
    } else {
      ref.read(empaquesProvider.notifier).resetEmpaques();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Empaque> empaques = ref.watch(empaquesProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Buscar empaque...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: _onSearchChanged,
          ),
        ),
        empaques.isNotEmpty
            ? Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Nombre',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Precio',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: empaques.length,
                        itemBuilder: (ctx, index) => EmpaqueInfo(
                          empaque: empaques[index],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const Center(
                child: Text('Ningún empaque!'),
              ),
      ],
    );
  }
}
