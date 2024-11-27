import 'package:flutter/material.dart';

class MyFormField extends StatelessWidget {
  const MyFormField({
    super.key,
    required this.obscureText,
    required this.label,
  });

  final bool obscureText;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        decoration: InputDecoration(
          label: Text(
            label,
            style:
                TextStyle(color: Theme.of(context).colorScheme.onPrimaryFixed),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade400,
            ),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
        obscureText: obscureText,
      ),
    );
  }
}
