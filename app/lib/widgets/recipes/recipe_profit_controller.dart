import 'package:flutter/material.dart';

class RecipeProfitController extends StatefulWidget {
  const RecipeProfitController({
    super.key,
    required this.onProfitChange,
  });

  final void Function(double) onProfitChange;

  @override
  State<RecipeProfitController> createState() {
    return __RecipeProfitControllerState();
  }
}

class __RecipeProfitControllerState extends State<RecipeProfitController> {
  final TextEditingController _profitController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _profitController,
              decoration: InputDecoration(
                labelText: 'Ganancia',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: Icon(
                  Icons.percent,
                  color: Theme.of(context).colorScheme.primary,
                  size: 34,
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final double? input = double.tryParse(value);
                if (input != null) {
                  widget.onProfitChange(input);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
