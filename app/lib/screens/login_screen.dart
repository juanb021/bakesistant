import 'package:flutter/material.dart';

import 'package:app/widgets/login_screen/login_form.dart';
import 'package:app/widgets/login_screen/login_button.dart';
import 'package:app/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 245, 245, 245),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                child: Image.asset('assets/images/logos/app_logo.png'),
              ),
              Text(
                'Por favor, inicia sesion',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryFixed,
                    fontSize: 16),
              ),
              const SizedBox(height: 15),
              const LoginForm(),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Expanded(
                        child: Divider(
                      thickness: 2,
                      color: Colors.grey,
                    )),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        'o continua con',
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 2,
                      color: Colors.grey,
                    )),
                  ],
                ),
              ),
              LoginButton(
                imgPath: 'assets/images/logos/google_logo.png',
                text: 'Inicia sesion con Google',
                login: authService.loginWithGoogle,
              ),
              const SizedBox(height: 50),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No tienes una cuenta?'),
                  Text(
                    '   Crea tu cuenta',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
