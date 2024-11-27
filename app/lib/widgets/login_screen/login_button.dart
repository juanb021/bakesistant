import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.imgPath,
    required this.text,
    required this.login,
  });

  final String imgPath;
  final String text;
  final Function login;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await login();
      },
      child: Container(
        margin: const EdgeInsets.all(25),
        decoration: BoxDecoration(
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Image.asset(
                imgPath,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryFixed,
                  fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
