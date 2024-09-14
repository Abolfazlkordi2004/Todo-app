import 'package:flutter/material.dart';
import 'package:todo_app/services/auth/auth_service.dart';

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
                    await AuthService.firebase().sendEmailVerification();
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
                    await AuthService.firebase().logOut();
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
