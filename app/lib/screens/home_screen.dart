// Libraries
import 'package:flutter/material.dart';

// Modules
import 'package:app/screens/recetas_screen.dart';
import 'package:app/screens/materials_screen.dart';
import 'package:app/widgets/home/homestack.dart';
import 'package:app/widgets/home/bot_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPageIndex = 0; // Track the currently selected page index

  // Update the selected page index
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  // Build the content based on the selected page index
  Widget _buildContent() {
    switch (_selectedPageIndex) {
      // Recipes page
      case 1:
        return const RecetasScreen();

      // Ingredients page
      case 2:
        return const MaterialsScreen();

      // Home page
      default:
        return const Homestack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildContent(), // Display the appropriate content
        bottomNavigationBar: BotNavigation(
          selectedPage: _selectedPageIndex,
          onSelectPage: _selectPage,
        ),
      ),
    );
  }
}
