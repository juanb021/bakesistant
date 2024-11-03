// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Modules
import 'package:app/models/package.dart';
import 'package:app/providers/packages_notifier.dart';
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

  // Handle search input changes to filter packages
  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      ref.read(packagesProvider.notifier).filterPackagesByName(query);
    } else {
      ref.read(packagesProvider.notifier).resetPackages();
    }
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose of the search controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Package> empaques =
        ref.watch(packagesProvider); // Watch the packages provider

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
            onChanged:
                _onSearchChanged, // Call onSearchChanged when input changes
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
                child: Text(
                    'Ningún empaque!'), // Message when no packages are available
              ),
      ],
    );
  }
}
