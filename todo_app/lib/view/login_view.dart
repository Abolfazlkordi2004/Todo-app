import 'package:flutter/material.dart';
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/dialogs/error_dialog.dart';
import 'package:todo_app/constant/username.dart';
import 'package:todo_app/services/auth/auth_exception.dart';
import 'package:todo_app/services/auth/auth_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginView();
}

class _LoginView extends State<LoginView> {
  late TextEditingController _userName;
  late TextEditingController _email;
  late TextEditingController _password;

  bool _passwordVisible = false;

  @override
  void initState() {
    _userName = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _userName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Text(
                  'Sign in',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.blue.shade900),
                ),
                const SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: _userName, // Added the controller
                  decoration: InputDecoration(
                    labelText: 'Username',
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
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _email, // Added the controller
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
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _password, // Added the controller
                  decoration: InputDecoration(
                    labelText: 'Password',
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
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !_passwordVisible,
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: 55,
                  width: 450,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        var email = _email.text;
                        var password = _password.text;
                        userName = _userName.text;

                        await AuthService.firebase()
                            .login(email: email, password: password);

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          homeRoute,
                          (route) => true,
                        );
                      } on WrongPasswordAuthException {
                        // ignore: use_build_context_synchronously
                        showErrordialog(context, 'Wrong password');
                      } on UserNotFoundAuthException {
                        // ignore: use_build_context_synchronously
                        showErrordialog(context, 'User not found');
                      } on GenericAuthExceptions {
                        // ignore: use_build_context_synchronously
                        showErrordialog(context, 'Unknown error');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      forgotPasswordRoute,
                      (route) => true,
                    );
                  },
                  child: const Text(
                    "Forgot password",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      registerRoute,
                      (route) => true,
                    );
                  },
                  child: const Text(
                    "Do not have account? Register here",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
