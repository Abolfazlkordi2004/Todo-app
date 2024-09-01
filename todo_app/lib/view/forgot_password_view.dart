import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/constant/routes.dart';
// import 'dart:developer' as devtools show log;
import 'package:todo_app/dialogs/error-dialog.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 1.5),
                  ),
                ),
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () async {
                  try {
                    var email = _emailController.text;
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: email);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'invalid-email') {
                      // devtools.log('Invalid email');
                      // ignore: use_build_context_synchronously
                      showErrordialog(context, 'Invalid email');
                    } else {
                      // devtools.log('Error ${e.code}');
                      // ignore: use_build_context_synchronously
                      showErrordialog(context, e.code);
                    }
                  }
                },
                child: const Text(
                  "Send me reset password",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(loginRoute);
                },
                child: const Text(
                  "Back to login",
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
