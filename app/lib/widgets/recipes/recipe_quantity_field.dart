import 'package:flutter/material.dart';

class RecipeQuantityField extends StatelessWidget {
  const RecipeQuantityField({
    super.key,
    required this.onSaved,
    required this.validator,
  });

  final FormFieldSetter onSaved;
  final FormFieldValidator validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Cantidad...',
        border: OutlineInputBorder(),
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }
}
