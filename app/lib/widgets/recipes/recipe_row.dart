import 'package:flutter/material.dart';

class RecipeRow extends StatelessWidget {
  const RecipeRow({
    super.key,
    required this.textA,
    required this.textB,
    required this.textC,
    required this.isBold,
    required this.size,
  });

  final String textA;
  final String textB;
  final String textC;
  final bool isBold;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              textA,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
                fontSize: size,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              textB,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
                fontSize: size,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              textC,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
                fontSize: size,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
