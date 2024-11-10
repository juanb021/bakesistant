import 'package:flutter/material.dart';

class FormController extends StatelessWidget {
  const FormController({
    super.key,
    required this.onFormSave,
  });

  final void Function() onFormSave;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: onFormSave,
          child: const Text('Guardar Receta'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'))
      ],
    );
  }
}
