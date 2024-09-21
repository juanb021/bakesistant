import 'package:app/widgets/home/bot_navigation.dart';
import 'package:flutter/material.dart';

import 'package:app/widgets/home/homestack.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Widget _buildContent() {
    switch (_selectedPageIndex) {
      case 1:
        return const Center(child: Text('Placeholder 1'));
      case 2:
        return const Center(child: Text('Placeholder 2'));
      case 3:
        return const Center(child: Text('Placeholder 3'));
      default:
        return const Homestack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: _buildContent(),
          bottomNavigationBar: BotNavigation(
              selectedPage: _selectedPageIndex, onSelectPage: _selectPage)),
    );
  }
}
