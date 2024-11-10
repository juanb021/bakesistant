import 'package:flutter/material.dart';

class RecipeNameField extends StatelessWidget {
  const RecipeNameField({
    super.key,
    required this.onSaved,
    required this.validator,
    this.recipe,
  });

  final FormFieldSetter onSaved;
  final FormFieldValidator validator;
  final String? recipe;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: recipe,
      decoration: InputDecoration(
        labelText: recipe ?? 'Nombre de la Receta...',
        border: const OutlineInputBorder(),
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }
}
