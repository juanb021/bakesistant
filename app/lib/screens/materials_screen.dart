import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/screens/empaques_screen.dart';
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
  bool _isIngredients = true;
  final TextEditingController _searchController = TextEditingController();

  void _swapScreens() {
    setState(() {
      _isIngredients = !_isIngredients;
    });
  }

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
        backgroundColor: Theme.of(context).colorScheme.primaryFixed,
        title: Text(
          _isIngredients ? 'Lista de Ingredientes' : 'Lista de Empaques',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        actions: [
          IconButton(
              onPressed: _swapScreens,
              icon: const Icon(
                Icons.swap_horiz,
                size: 30,
              )),
          IconButton(
              onPressed: _openAddItemOverlay,
              icon: const Icon(
                Icons.add,
                size: 34,
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
