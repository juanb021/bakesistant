import 'package:flutter/material.dart';

class BotNavigation extends StatefulWidget {
  const BotNavigation(
      {super.key, required this.selectedPage, required this.onSelectPage});

  final int selectedPage;
  final Function(int) onSelectPage;

  @override
  State<BotNavigation> createState() {
    return _BotNavigationState();
  }
}

class _BotNavigationState extends State<BotNavigation> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.selectedPage,
      onTap: widget.onSelectPage,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.secondary,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_rounded),
          label: 'Recetario',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_dining),
          label: 'Ingredientes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: 'Proveedores',
        ),
      ],
    );
  }
}
