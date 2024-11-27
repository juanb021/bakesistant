import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:app/widgets/login_screen/my_form_field.dart';
import 'package:app/widgets/login_screen/sign_in_button.dart';
import 'package:app/services/auth_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  State<StatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  final form = GlobalKey<FormState>();
  String mail = '';
  String password = '';

  void _submit() async {
    if (!form.currentState!.validate()) {
      return;
    }

    form.currentState!.save();

    try {
      final authService = AuthService();
      User? user = await authService.loginWithEmail(mail, password);

      if (!mounted) return;
      if (user != null) {
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario o contraseña inválidos')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ocurrió un error. Intenta nuevamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: form,
      child: Column(
        children: [
          // Email Field
          const MyFormField(obscureText: false, label: 'Correo Electronico'),
          const SizedBox(height: 15),

          // Password Field
          const MyFormField(obscureText: true, label: "Contraseña"),
          const SizedBox(height: 15),

          // Forgot my password
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(
                  'Olvide mi contraseña',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ])),

          // Sign in button
          const SizedBox(height: 15),
          SignInButton(
            login: _submit,
          ),
        ],
      ),
    );
  }
}
