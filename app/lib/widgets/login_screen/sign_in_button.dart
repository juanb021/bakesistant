import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({
    super.key,
    required this.login,
  });

  final Function login;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 58, 171, 72),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
            child: Text('Iniciar Sesion',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold))),
      ),
    );
  }
}
