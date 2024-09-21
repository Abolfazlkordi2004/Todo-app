import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Responsive/responsive.dart';
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/helper/space.dart';
import 'package:todo_app/utilities.dart/dialogs/error_dialog.dart';
import 'package:todo_app/services/auth/auth_exception.dart';
// import 'dart:developer' as devtools show log;

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordView> {
  late TextEditingController _emailController;

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Responsive().init(constraints: constraints);
        return Scaffold(
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(4 * Responsive().widthConfige),
              child: Column(
                children: [
                  heightSizedBox(3),
                  Text(
                    'Forgot password',
                    style: TextStyle(
                        fontSize: 2.5 * Responsive().textConfige,
                        fontWeight: FontWeight.bold),
                  ),
                  heightSizedBox(2),
                  const Divider(
                    color: Colors.grey,
                    indent: 10,
                    endIndent: 10,
                  ),
                  heightSizedBox(2),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(width: 1.5),
                      ),
                    ),
                    autocorrect: false,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  heightSizedBox(2),
                  TextButton(
                    onPressed: () async {
                      try {
                        var email = _emailController.text;
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email);
                      } on InvalidEmailAuthExceptions {
                        // ignore: use_build_context_synchronously
                        showErrordialog(context, 'Invalid email');
                      } on GenericAuthExceptions {
                        // ignore: use_build_context_synchronously
                        showErrordialog(context, 'Unknown error');
                      }
                    },
                    child: const Text(
                      "Send me reset password",
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(loginRoute);
                    },
                    child: const Text(
                      "Back to login",
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
