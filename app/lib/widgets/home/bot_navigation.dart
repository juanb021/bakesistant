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
      unselectedItemColor: Theme.of(context).colorScheme.onTertiaryContainer,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 30,
          ),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.menu_book_rounded,
            size: 30,
          ),
          label: 'Recetario',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.list,
            size: 30,
          ),
          label: 'Materiales',
        ),
      ],
    );
  }
}
