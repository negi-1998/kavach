import 'package:flutter/material.dart';

class LoginIncorrect extends StatelessWidget {
  const LoginIncorrect({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: const BorderSide(color: Colors.black, width: 2),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Colors.red,
              Colors.redAccent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: IntrinsicWidth(
          child: IntrinsicHeight(
            child: Theme(
              data: Theme.of(context).copyWith(
                dialogBackgroundColor: Colors.transparent,
                textTheme: const TextTheme(
                  bodyLarge: TextStyle(color: Colors.white),
                  bodyMedium: TextStyle(color: Colors.white),
                  titleMedium: TextStyle(color: Colors.white),
                ),
              ),
              child: AlertDialog(
                title: const Text('Incorrect details'),
                content: const SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                        'Either E-mail or password is incorrect.',
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
