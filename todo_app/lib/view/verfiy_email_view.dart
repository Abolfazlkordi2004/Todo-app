import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/constant/routes.dart';
import 'dart:developer' as devtools show log;

class VerfiyEmailView extends StatefulWidget {
  const VerfiyEmailView({super.key});

  @override
  State<VerfiyEmailView> createState() => _VerfiyEmailViewState();
}

class _VerfiyEmailViewState extends State<VerfiyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verfiy Email'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "we ve' sent you an email verification.please open it to verify your account",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "If you haven't received a verification email yet, press the button below",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: 250,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final user = FirebaseAuth.instance.currentUser;
                      await user?.sendEmailVerification();
                    } on FirebaseAuthException catch (e) {
                      devtools.log('Error ${e.code}');
                    }
                  },
                  style: ElevatedButton.styleFrom(),
                  child: const Text('send Email verfication'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 250,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (route) => false,
                      );
                    } on FirebaseAuthException catch (e) {
                      devtools.log('Error ${e.code}');
                    }
                  },
                  child: const Text('restart'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
