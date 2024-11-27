// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Modules
import 'package:app/screens/packages_screen.dart';
import 'package:app/screens/ingredients_screen.dart';
import 'package:app/widgets/empaque/empaque_form.dart';
import 'package:app/widgets/ingredients/ingredient_form.dart';

class MaterialsScreen extends ConsumerStatefulWidget {
  const MaterialsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MaterialsScreenState();
  }
}

class _MaterialsScreenState extends ConsumerState<MaterialsScreen> {
  bool _isIngredients = true; // Track if ingredients are displayed
  final TextEditingController _searchController = TextEditingController();

  // Swap between ingredients and packages screens
  void _swapScreens() {
    setState(() {
      _isIngredients = !_isIngredients;
    });
  }

  // Open the overlay to add an ingredient or package
  void _openAddItemOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) =>
          _isIngredients ? const IngredientForm() : const EmpaqueForm(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          _isIngredients ? 'Lista de Ingredientes' : 'Lista de Empaques',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: _swapScreens,
              icon: const Icon(
                Icons.swap_horiz,
                size: 30,
                color: Colors.white,
              )),
          IconButton(
              onPressed: _openAddItemOverlay,
              icon: const Icon(
                Icons.add,
                size: 34,
                color: Colors.white,
              )),
        ],
      ),
      body: Center(
        child:
            _isIngredients ? const IngredientsScreen() : const EmpaquesScreen(),
      ),
    );
  }
}
